require 'nark'

class TestSignup
  include Nark

  def self.collection_name
    :test_signups
  end

  attr_reader :serializable_hash

  def initialize(attributes)
    @serializable_hash = attributes
  end
end

describe TestSignup do
  it 'should emit event to keen' do
    expect(Keen).to \
      receive(:publish).with :test_signups, user_name: 'everydayhero'
    TestSignup.new(user_name: 'everydayhero').emit
  end

  it 'should emit event to keen with specific timestamp' do
    time = Time.now
    expect(Keen).to \
      receive(:publish).with :test_signups, user_name: 'everydayhero',
      keen: { timestamp: time }
    TestSignup.new(user_name: 'everydayhero').emit timestamp: time
  end
end