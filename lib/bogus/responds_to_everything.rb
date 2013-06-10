module Bogus
  class RespondsToEverything
    include FakeObject
    include RecordInteractions

    def initialize
      __shadow__
    end

    def respond_to?(method)
      true
    end

    def method_missing(name, *args, &block)
      __record__(name, *args, &block)
    end
  end
end
