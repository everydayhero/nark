require 'nark'

describe Nark::EventGatewayEmitter do
  let(:client) { FakeFaraday.new }
  let(:emitter) do
    Nark::EventGatewayEmitter.new.tap do |emitter|
      emitter.instance_variable_set :@faraday, client
    end
  end

  it 'should post the correct data structure on the gateway' do
    data = { hello: 'hi' }
    target = { name: 'collection', time: Time.now.to_i, payload: data }.to_json
    emitter.emit :collection, data

    expect(client.request.body).to eq(target)
  end

  it 'should write data to collection with correct time if present in the event' do
    t = 123
    data = { hello: 'hi', time: t }
    target = { name: 'collection', time: t, payload: data }.to_json
    emitter.emit :collection, data

    expect(client.request.body).to eq(target)
  end

  it 'should override event time if explicitly given' do
    data = { hello: 'hi', time: Time.now.to_i }
    target = { name: 'collection', time: 42, payload: data }.to_json
    emitter.emit :collection, data, 42

    expect(client.request.body).to eq(target)
  end

  it 'should bulk emit data to multiple collections' do
    time = Time.now.to_i
    data_1 = { hello: 'hi', time: 123 }
    data_2 = { hello: 'hi', time: 456 }
    events = {
      c_1: [data_1],
      c_2: [data_1, data_2]
    }
    target = [
      {name:"c_1",time:123,payload:{hello:"hi",time:123}},
      {name:"c_2",time:123,payload:{hello:"hi",time:123}},
      {name:"c_2",time:456,payload:{hello:"hi",time:456}}
    ].to_json
    emitter.emit_bulk events

    expect(client.request.body).to eq(target)
  end

  private

  class FakeFaraday
    def post
      yield request

      OpenStruct.new status: 201
    end

    def request
      @request ||= OpenStruct.new
    end
  end
end
