module Nark
  class Emitter
    def emit(collection_name, data, timestamp = nil)
      fail NotImplementError
    end

    def emit_bulk(data_hash)
      fail NotImplementError
    end
  end
end
