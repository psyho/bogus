module Bogus
  class RespondsToEverything
    include RecordInteractions

    def respond_to?(method)
      true
    end

    def method_missing(name, *args, &block)
      __record__(name, *args, &block)
    end
  end
end
