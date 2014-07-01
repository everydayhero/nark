require 'nark/version'
require 'keen'

module Nark
  def self.included(klass)
    klass.extend ClassMethods
  end

  def serializable_hash(value = nil)
    @serializable_hash = value if value
    @serializable_hash
  end

  def emit(timestamp: nil)
    hash = serializable_hash.clone
    hash.merge! keen: { timestamp: timestamp } if timestamp
    Keen.publish self.class.collection_name, hash
    self
  end

  module ClassMethods
    def collection_name(value = nil)
      @collection_name = value if value
      @collection_name
    end
  end
end
