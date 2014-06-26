require 'nark/version'
require 'keen'

module Nark
  def emit(timestamp: nil)
    hash = serializable_hash
    hash.merge! keen: { timestamp: timestamp } if timestamp
    Keen.publish self.class.collection_name, serializable_hash
  end
end
