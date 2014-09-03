require 'influxdb'
require 'nark/emitter'

module Nark
  class InfluxDBEmitter < Nark::Emitter
    def initialize(*args)
      @influxdb_client = InfluxDB::Client.new(*args)
    end

    def emit(collection_name, data, timestamp = nil)
      data.merge!(time: timestamp.to_i) if timestamp

      influxdb_client.write_point(collection_name, data)
    end

    def emit_bulk(data_hash)
      data_hash.each do |collection_name, data|
        influxdb_client.write_point(collection_name, data)
      end
    end

    private

    attr_reader :influxdb_client
  end
end
