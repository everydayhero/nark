require 'nark/version'
require 'keen'

module Nark
  def self.included(klass)
    klass.extend ClassMethods
  end

  attr_reader :serializable_hash

  def emit(timestamp: nil)
    hash = serializable_hash
    hash.merge! keen: { timestamp: timestamp } if timestamp
    Keen.publish self.class.collection_name, serializable_hash
    self
  end

  module ClassMethods
    def collection_name(value = nil)
      @collection_name = value if value
      @collection_name
    end
  end
end
