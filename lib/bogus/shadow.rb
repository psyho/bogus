module Bogus
  class Shadow
    attr_reader :calls

    def initialize
      @calls = []
      @stubs = []
      @required = Set.new
    end

    def run(method_name, *args)
      interaction = Interaction.new(method_name, args)
      @calls << interaction
      return_value(interaction)
    end

    def has_received(name, args)
      @calls.any? { |i| Interaction.same?(recorded: i, stubbed: Interaction.new(name, args)) }
    end

    def stubs(name, *args, &return_value)
      interaction = Interaction.new(name, args)
      add_stub(interaction, return_value)
      @required.reject! { |i| Interaction.same?(recorded: i, stubbed: interaction) }
      interaction
    end

    def mocks(name, *args, &return_value)
      interaction = stubs(name, *args, &return_value)
      @required.add(interaction)
    end

    def unsatisfied_interactions
      @required.reject do |stubbed|
        @calls.any? do |recorded|
          Interaction.same?(recorded: recorded, stubbed: stubbed)
        end
      end
    end

    def self.has_shadow?(object)
      object.respond_to?(:__shadow__)
    end

    private

    def add_stub(interaction, return_value_block)
      @stubs << [interaction, return_value_block] if return_value_block
    end

    def return_value(interaction)
      _, return_value = @stubs.reverse.find{|i, v| Interaction.same?(recorded: interaction, stubbed: i)}
      return_value ||= proc{ UndefinedReturnValue.new(interaction) }
      return_value.call
    end
  end
end
