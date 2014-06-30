require 'nark'

class TestSignup
  include Nark

  collection_name :test_signups

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
      receive(:publish).with :test_signups,
                             user_name: 'everydayhero',
                             keen: { timestamp: time }
    TestSignup.new(user_name: 'everydayhero').emit timestamp: time
  end

  it 'should emit returning self' do
    allow(Keen).to receive :publish
    signup = TestSignup.new({})
    expect(signup.emit).to eq(signup)
  end
end
