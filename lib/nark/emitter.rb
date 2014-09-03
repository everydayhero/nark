module Nark
  class Emitter
    def emit(collection_name, data, timestamp = nil)
      fail NotImplementError
    end
  end
end
