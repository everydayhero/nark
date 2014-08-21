require 'nark'

describe Nark::InfluxDBEmitter do
  let(:client) { Object }
  let(:emitter) do
    Nark::InfluxDBEmitter.new.tap do |emitter|
      emitter.instance_variable_set :@influxdb_client, client
    end
  end

  it 'should write data to right collection on influxdb' do
    data = { hello: 'hi' }
    expect(client).to \
      receive(:write_point).with :collection, data

    emitter.emit :collection, data
  end

  it 'should write data to collection with correct time' do
    data = { hello: 'hi' }
    time = Time.now
    expect(client).to \
      receive(:write_point).with :collection, data.merge(time: time.to_i)

    emitter.emit :collection, data, time
  end

  it 'should bulk emit data to multiple collections' do
    data = { hello: 'hi', time: Time.now.to_i }
    events = {
      c_1: [data],
      c_2: [data, data]
    }
    expect(client).to receive(:write_point).with :c_1, [data]
    expect(client).to receive(:write_point).with :c_2, [data, data]

    emitter.emit_bulk events
  end
end
