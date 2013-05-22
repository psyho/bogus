require 'spec_helper'

describe Bogus::Interaction do
  class SomeError < StandardError; end

  same = [
    [[:foo, [:bar], "value"], [:foo, [:bar], "value"]],
    [[:foo, [:bar]], [:foo, [:bar], "value"]],
    [[:foo, [:bar], "value"], [:foo, [:bar]]],
    [[:foo, [:bar]], [:foo, [:bar]]],
    [[:foo, [Bogus::AnyArgs]], [:foo, [:bar]]],
    [[:foo, [:bar]], [:foo, [Bogus::AnyArgs]]],
    [[:foo, [Bogus::AnyArgs], "same value"], [:foo, [:bar], "same value"]],
    [[:foo, [:bar], "same value"], [:foo, [Bogus::AnyArgs], "same value"]],
    [[:foo, [:bar, Bogus::Anything]], [:foo, [:bar, :baz]]],
    [[:foo, [:bar, :baz]], [:foo, [:bar, Bogus::Anything]]],
    [[:foo, [:bar, Bogus::Anything]], [:foo, [Bogus::Anything, :baz]]]
  ]

  different = [
    [[:foo, [:bar], "value"], [:foo, [:bar], "value2"]],
    [[:foo, [:bar], "value"], [:baz, [:bar], "value"]],
    [[:foo, [:baz], "value"], [:foo, [:bar], "value"]],
    [[:foo, [Bogus::AnyArgs]], [:bar, [:bar]]],
    [[:foo, [:bar]], [:bar, [Bogus::AnyArgs]]],
    [[:foo, [Bogus::AnyArgs], "some value"], [:foo, [:bar], "other value"]],
    [[:foo, [:bar], "some value"], [:foo, [Bogus::AnyArgs], "other value"]],
    [[:foo, [:bar]], [:foo, [:baz]]],
    [[:baz, [:bar]], [:foo, [:bar]]]
  ]

  def create_interaction(interaction)
    method_name, args, return_value = interaction
    if return_value
      Bogus::Interaction.new(method_name, args) { return_value }
    else
      Bogus::Interaction.new(method_name, args)
    end
  end

  same.each do |first_interaction, second_interaction|
    it "returns true for #{first_interaction.inspect} and #{second_interaction.inspect}" do
      first = create_interaction(first_interaction)
      second = create_interaction(second_interaction)

      first.should == second
    end
  end

  different.each do |first_interaction, second_interaction|
    it "returns false for #{first_interaction.inspect} and #{second_interaction.inspect}" do
      first = create_interaction(first_interaction)
      second = create_interaction(second_interaction)

      first.should_not == second
    end
  end

  it "differs exceptions from empty return values" do
    first = Bogus::Interaction.new(:foo, [:bar]) { raise SomeError }
    second = Bogus::Interaction.new(:foo, [:bar]) { nil }

    first.should_not == second
  end

  it "differs raised exceptions from ones just returned from the block" do
    first = Bogus::Interaction.new(:foo, [:bar]) { raise SomeError }
    second = Bogus::Interaction.new(:foo, [:bar]) { SomeError }

    first.should_not == second
  end

  it "considers exceptions of the same type as equal" do
    first = Bogus::Interaction.new(:foo, [:bar]) { raise SomeError }
    second = Bogus::Interaction.new(:foo, [:bar]) { raise SomeError }

    first.should == second
  end

  it 'properly compares arguments with custom #== implementations' do
    class Dev
      attr_reader :login
      def initialize(login); @login = login; end
      def ==(other); login == other.login;   end
    end
    psyho, wrozka, yundt = Dev.new(:psycho), Dev.new(:wrozka), Dev.new(:yundt)
    psyho_int  = Bogus::Interaction.new :with, [psyho]
    wrozka_int = Bogus::Interaction.new :with, [wrozka]
    yundt_int  = Bogus::Interaction.new :with, [yundt]

    psyho_int.should      == psyho_int
    wrozka_int.should_not == yundt_int
  end
end
