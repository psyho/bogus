module Bogus
  class Shadow
    attr_reader :calls

    def initialize(object)
      @object = object
      @calls = []
      @stubs = {}
      @required = Set.new
    end

    def run(method_name, *args)
      interaction = Interaction.new(method_name, args)
      @calls << interaction
      return_value(interaction)
    end

    def has_received(name, args)
      @calls.include?(Interaction.new(name, args))
    end

    def stubs(name, *args, &return_value)
      interaction = Interaction.new(name, args)
      add_stub(interaction, return_value)
      @required.delete(interaction)
    end

    def stub
      proxy(:stubs)
    end

    def mocks(name, *args, &return_value)
      interaction = Interaction.new(name, args)
      add_stub(interaction, return_value)
      @required.add(interaction)
    end

    def mock
      proxy(:mocks)
    end

    def unsatisfied_interactions
      @required.to_a - @calls
    end

    private

    def proxy(method_name)
      MethodCallProxy.new do |name, *args, &return_value|
        __send__(method_name, name, *args, &return_value)
      end
    end

    def add_stub(interaction, return_value_block)
      @stubs[interaction] = return_value_block if return_value_block
    end

    def return_value(interaction)
      return_value = @stubs.fetch(interaction, proc{ @object })
      return_value.call
    end
  end

  class MethodCallProxy < BasicObject
    def initialize(&on_called)
      @on_called = on_called
    end

    def method_missing(name, *args, &block)
      @on_called.call(name, *args, &block)
    end
  end
end
