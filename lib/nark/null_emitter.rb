require 'nark/emitter'

module Nark
  class NullEmitter < Nark::Emitter
    def emit(collection_name, data, timestamp = nil); end

    def emit_bulk(data_hash); end
  end
end

