require 'faraday'
require 'faraday_middleware'
require 'nark/emitter'

module Nark
  class EventGatewayEmitter < Nark::Emitter
    def initialize(options = {})
      @url = options.fetch :url, ENV['EVENT_GATEWAY_URL']
    end

    def emit(collection_name, data, timestamp = nil)
      timestamp = data.fetch(:time, Time.now.to_i) unless timestamp
      data = { name: collection_name, time: timestamp, payload: data }
      post data
    end

    def emit_bulk(data_hash)
      data = data_hash.map do |collection_name, event_data|
        event_data.map do |datum|
          timestamp = datum.fetch(:time, Time.now.to_i)
          { name: collection_name, time: timestamp, payload: datum }
        end
      end.flatten
      post data
    end

    private

    attr_reader :url

    def faraday
      @faraday ||= Faraday.new(:url => url) do |faraday|
        faraday.request :json
        faraday.adapter Faraday.default_adapter
      end
    end

    def post data
      response = @faraday.post do |request|
        request.body = data.to_json
      end
      response.status == 201
    end
  end
end
