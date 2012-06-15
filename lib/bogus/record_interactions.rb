module Bogus
  module RecordInteractions
    def __inner_object__
      @__inner_object__ ||= Object.new
    end

    def __stub__
      @__stub__ ||= RRProxy.stub(__inner_object__)
    end

    def __record__(method, *args, &block)
      __stub__.__send__(method, *args)
      __inner_object__.__send__(method, *args, &block)
      self
    end
  end
end
