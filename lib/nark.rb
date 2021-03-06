require 'nark/version'
require 'nark/influxdb_emitter'
require 'nark/null_emitter'
require 'nark/event_gateway_emitter'
require 'nark/emitter'

module Nark
  def self.included(klass)
    klass.extend ClassMethods
  end

  def serializable_hash(value = nil)
    @serializable_hash = value if value
    @serializable_hash
  end

  def emit(timestamp: nil)
    hash = serializable_hash.clone
    Nark.emitter.emit(collection_name, hash, timestamp)

    self
  end

  def collection_name(name = nil)
    @collection_name = name if name
    @collection_name ||= self.class.collection_name

    @collection_name
  end

  module ClassMethods
    def collection_name(value = nil)
      @collection_name = value if value
      @collection_name
    end

    def emit(narks = [])
      return if narks.empty?

      nark_hash =
        narks.each_with_object(Hash.new { |h, k| h[k] = [] }) do |nark, hash|
          hash[nark.collection_name] << nark.serializable_hash
        end

      Nark.emitter.emit_bulk(nark_hash)
    end
  end

  class << self
    attr_writer :emitter

    def configure(&block)
      block.call self
    end

    def emitter
      @emitter ||= if use_influxdb_emitter?
        influxdb_emitter
      else
        NullEmitter.new
      end
    end

    private

    def use_influxdb_emitter?
      !!influxdb_database
    end

    def influxdb_database
      ENV['INFLUXDB_DATABASE']
    end

    def influxdb_emitter
      InfluxDBEmitter.new(
        influxdb_database,
        username: ENV['INFLUXDB_USERNAME'],
        password: ENV['INFLUXDB_PASSWORD'],
        hosts: ENV['INFLUXDB_HOST'],
        port: ENV['INFLUXDB_PORT'],
        use_ssl: ENV['INFLUXDB_USE_SSL']
      )
    end
  end
end
