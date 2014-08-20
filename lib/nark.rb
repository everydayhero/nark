require 'nark/version'
require 'nark/influxdb_emitter'

module Nark
  def self.included(klass)
    klass.extend ClassMethods
  end

  def serializable_hash(value = nil)
    @serializable_hash = value if value
    @serializable_hash
  end

  def emit(collection_name: nil, timestamp: nil)
    collection = collection_name || self.class.collection_name
    hash = serializable_hash.clone
    Nark.emitter.emit(collection, hash, timestamp)

    self
  end

  module ClassMethods
    def collection_name(value = nil)
      @collection_name = value if value
      @collection_name
    end
  end

  class << self
    attr_writer :emitter

    def configure(&block)
      block.call self
    end

    def emitter
      @emitter ||= InfluxDBEmitter.new(
        ENV['INFLUXDB_DATABASE'],
        username: ENV['INFLUXDB_USERNAME'],
        password: ENV['INFLUXDB_PASSWORD'],
        hosts: ENV['INFLUXDB_HOST'],
        port: ENV['INFLUXDB_PORT'],
        use_ssl: ENV['INFLUXDB_USE_SSL']
      )
    end
  end
end
