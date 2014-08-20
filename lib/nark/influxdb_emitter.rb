require 'influxdb'

module Nark
  class InfluxDBEmitter
    def initialize(*args)
      @influxdb_client = InfluxDB::Client.new(*args)
    end

    def emit(collection_name, data, timestamp = nil)
      data.merge!(time: timestamp.to_i) if timestamp

      influxdb_client.write_point(collection_name, data)
    end

    private

    attr_reader :influxdb_client
  end
end
