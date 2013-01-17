require 'rr'

module Bogus
  class InvocationMatcher < RR::Adapters::Rspec::InvocationMatcher
    def initialize(method, verifies_stub_definition, records_double_interactions)
      super(method)
      @verifies_stub_definition = verifies_stub_definition
      @records_double_interactions = records_double_interactions
      @stubbed_method_calls = []
    end

    def matches?(subject)
      @stubbed_method_calls.each do |name, args|
        @verifies_stub_definition.verify!(subject, name, args)
        @records_double_interactions.record(subject, name, args)
      end

      if subject.respond_to?(:__shadow__)
        shadow = subject.__shadow__
        return @stubbed_method_calls.all?{|name, args| shadow.has_received(name, args)}
      end

      return super(subject)
    end

    def method_missing(name, *args, &block)
      @stubbed_method_calls << [name, args]
      super
    end
  end
end
