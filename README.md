# Nark

Ruby API for sending generic events for analytics purpose. Currently it assumes the **InfluxDB** is the receiving end.


## Installation

Add this line to your application's Gemfile:

    gem 'nark'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nark

## Usage

### Configuration

As Nark currently only supports InfluxDB, the simplest way to set it up is by providing the set of required InfluxDB specific environment variables:

```ruby
ENV['INFLUXDB_DATABASE'] # required, eg. supporter-events
ENV['INFLUXDB_USERNAME'] # required
ENV['INFLUXDB_PASSWORD'] # required
ENV['INFLUXDB_HOST']     # optional, default to localhost
ENV['INFLUXDB_PORT']     # optional, default to 8086
ENV['INFLUXDB_USE_SSL']  # optional, default to false
```

To provide more sophisticated configurations, the `Nark.configure` helper can be utilised, for example:

```ruby
Nark.configure do |nark|
  nark.emitter = Nark::InfluxDBEmitter.new database: 'some_db'
end
```

### Making object emittable

The `Nark` module is meant to be used as mixin that enables object to emit itself as event. The following code snippet shows a basic use case:

```ruby
class TestSignup
  include Nark

  collection_name :test_signups

  def initialize attributes
    serializable_hash attributes #entire attributes hash will be send as event data
  end
end
```

With the above setting, it makes all of the `TestSignup` events to be send to the `test_signups` collection, as the `collection_name` is set in the class level.
The following shows how to emit the event object:

```ruby
TestSignup.new.emit
```

By default, the timestamp of the event will be set to the time when the event is received, it is also possible to explicitly set the timestamp:

```ruby
TestSignup.new.emit timestamp: Time.now
```

Or if the serialised event data contains the `time` field (need to be in numeric UNIX timestamp format), it will be used as the timestamp:

```ruby
TestSignup.new(time: Time.now.i).emit
```


Sometimes it is desirable to make the same type of objects to be send to different collections:

```ruby
class TestSignup
  include Nark

  def initialize attributes
    collection_name "test_signups_#{Date.today}"
    serializable_hash attributes
  end
end
```

The above example will send the events to new collections each day.


### Bulk Emit

Nark also allows events to be send in bulk:

```ruby
events = 10.times.map { TestSignup.new }

TestSignup.emit events
```

Please note, when sending events in bulk, it is good idea to have the `time` field explicitly included in the serialised hash, otherwise the events will have the same timestamp set.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/nark/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
