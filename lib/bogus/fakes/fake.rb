module Bogus
  module FakeObject
    # marker for fake objects
  end

  class Fake
    include RecordInteractions
    extend RecordInteractions
    include FakeObject
    extend FakeObject

    def initialize(*args)
      __shadow__
    end

    def to_s
      "#<#{self.class}:0x#{object_id.to_s(16)}>"
    end

    def kind_of?(klass)
      copied_class = self.class.__copied_class__
      super || BaseClassIdentifier.base_class?(copied_class, klass)
    end

    alias :instance_of? :kind_of?
    alias :is_a? :kind_of?

    class << self
      alias :__create__ :new

      def new(*args, &block)
        __record__(:new, *args, &block)
        __create__
      end
    end
  end
end
