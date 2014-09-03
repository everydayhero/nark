require 'faraday'
require 'faraday_middleware'
require 'nark/emitter'

module Nark
  class EventGatewayEmitter < Nark::Emitter
    def initialize(*args)
      @faraday = Faraday.new(:url => ENV['EVENT_GATEWAY_URL']) do |faraday|
        faraday.request :json
        faraday.adapter Faraday.default_adapter
      end
    end

    def emit(collection_name, data, timestamp = nil)
      timestamp = data.fetch('time', Time.now.to_i) unless timestamp
      response = @faraday.post do |request|
        request.body = { name: collection_name, time: timestamp, payload: data}.to_json
      end
      raise "Bad response status" unless [200, 201].include? response.status
    end

    def emit_bulk(data_hash)
      data = data_hash.map do |collection_name, event_data|
        event_data.map do |datum|
          timestamp = datum.fetch('time', Time.now.to_i)
          { name: collection_name, time: timestamp, payload: datum}
        end
      end.flatten

      @faraday.post do |request|
        request.body = data.to_json
      end
    end

    private

    attr_reader :faraday
  end
end
