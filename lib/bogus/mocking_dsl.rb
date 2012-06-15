require 'rr'

module Bogus
  module MockingDSL
    def injector
      @injector ||= Bogus::Injector.new
    end

    def stub(object)
      injector.creates_stubs.create(object)
    end

    def have_received(method = nil)
      InvocationMatcher.new(method, injector.verifies_stub_definition)
    end

    class InvocationMatcher < RR::Adapters::Rspec::InvocationMatcher
      def initialize(method, verifies_stub_definition)
        super(method)
        @verifies_stub_definition = verifies_stub_definition
        @stubbed_method_calls = []
      end

      def matches?(subject)
        @stubbed_method_calls.each do |name, args|
          @verifies_stub_definition.verify!(subject, name, args)
        end

        super(subject.__inner_object__)
      end

      def method_missing(name, *args, &block)
        @stubbed_method_calls << [name, args]
        super
      end
    end
  end
end
