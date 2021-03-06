require 'nark'

class TestSignup
  include Nark

  collection_name :test_signups

  def initialize(attributes = {})
    serializable_hash attributes
  end
end

describe TestSignup do
  let(:emitter) { Object }

  before do
    Nark.configure do |nark|
      nark.emitter = emitter
    end
  end

  it 'should emit event to emitter' do
    expect(emitter).to \
      receive(:emit).with :test_signups, { user_name: 'everydayhero' }, nil

    TestSignup.new(user_name: 'everydayhero').emit
  end

  it 'should emit event with specific timestamp' do
    time = Time.now
    expect(emitter).to \
      receive(:emit).with :test_signups, { user_name: 'everydayhero' }, time

    TestSignup.new(user_name: 'everydayhero').emit timestamp: time
  end

  it 'should emit event with specific collection_name' do
    expect(emitter).to \
      receive(:emit).with 'signup2', { user_name: 'everydayhero' }, nil

    TestSignup.new(user_name: 'everydayhero').tap do |signup|
      signup.collection_name 'signup2'
    end.emit
  end

  it 'should not mutate serializable_hash' do
    allow(emitter).to receive :emit
    signup = TestSignup.new({})
    signup.emit timestamp: Time.now
    expect(signup.serializable_hash).to eq({})
  end

  it 'should emit returning self' do
    allow(emitter).to receive :emit
    signup = TestSignup.new({})

    expect(signup.emit).to eq(signup)
  end

  it 'should emit mutiple events based on the configured collection_name' do
    bulk_events_data = {
      test_signups: [{}],
      signup_1: [{}, {}]
    }
    expect(emitter).to receive(:emit_bulk).with bulk_events_data

    events = [
      TestSignup.new,
      TestSignup.new.tap { |event| event.collection_name :signup_1 },
      TestSignup.new.tap { |event| event.collection_name :signup_1 }
    ]

    TestSignup.emit(events)
  end
end
