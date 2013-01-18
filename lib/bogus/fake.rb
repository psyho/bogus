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
    end

    def to_s
      "#<#{self.class}:0x#{object_id.to_s(16)}>"
    end

    def kind_of?(klass)
      klass == self.class.__copied_class__
    end

    def instance_of?(klass)
      klass == self.class.__copied_class__
    end

    class << self
      attr_accessor :__copied_class__

      def name
        __copied_class__.name
      end

      def to_s
        name
      end
    end
  end
end
