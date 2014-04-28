require 'spec_helper'

describe Bogus::InteractionsRepository do
  let(:interactions_repository) { Bogus::InteractionsRepository.new }

  def recorded?(fake_name, method, *args)
    interactions_repository.recorded?(fake_name, Bogus::Interaction.new(method, args))
  end

  it "considers the interaction recorded if it was recorded previously" do
    interactions_repository.record(:foo, :bar, 1, 2, 3)

    expect(recorded?(:foo, :bar, 1, 2, 3)).to be_true
  end

  it "considers the interaction recorded if it returned the same value as passed block" do
    interactions_repository.record(:foo, :bar) { "a result" }
    interaction = Bogus::Interaction.new(:bar, []) { "a result" }

    expect(interactions_repository.recorded?(:foo, interaction)).to be_true
  end

  it "does not consider any interactions recorded prior to any recordings" do
    expect(recorded?(:foo, :bar, 1)).to be_false
  end

  it "does not consider the interaction recorded with a different fake name"  do
    interactions_repository.record(:baz, :bar, 1)

    expect(recorded?(:foo, :bar, 1)).to be_false
  end

  it "does not consider the interaction recorded with a different method name" do
    interactions_repository.record(:foo, :baz, 1)

    expect(recorded?(:foo, :bar, 1)).to be_false
  end

  it "does not consider the interaction recorded with different method arguments" do
    interactions_repository.record(:foo, :bar, 1, 2)

    expect(recorded?(:foo, :bar, 1)).to be_false
  end

  it "returns a list of interactions for given fake" do
    interactions_repository.record(:foo, :bar, 1, 2)

    interactions = interactions_repository.for_fake(:foo)
    expect(interactions).to have(1).item
    expect(interactions.first.method).to eq :bar
    expect(interactions.first.args).to eq [1, 2]
  end

  it "ignores arguments if the checked interaction has any_args" do
    interactions_repository.record(:foo, :bar, 1)

    expect(recorded?(:foo, :bar, Bogus::AnyArgs)).to be_true
  end

  it "takes method name into account when matching interaction with wildcard arguments" do
    interactions_repository.record(:foo, :baz, 1)

    expect(recorded?(:foo, :bar, Bogus::AnyArgs)).to be_false
  end

  it "ignores arguments if the recorded interaction was recorded with wildcard argument" do
    interactions_repository.record(:foo, :bar, 1, 2)

    expect(recorded?(:foo, :bar, 1, Bogus::Anything)).to be_true
  end

  it "takes other arguments into account when matching interactions with wildcards" do
    interactions_repository.record(:foo, :bar, 1, 2)

    expect(recorded?(:foo, :bar, 2, Bogus::Anything)).to be_false
  end

  it "ignores arguments if the checked interaction has any_args" do
    interactions_repository.record(:foo, :bar, 1, 2)

    expect(recorded?(:foo, :bar, 1, Bogus::Anything)).to be_true
  end

  it "takes method name into account when matching interaction with wildcard arguments" do
    interactions_repository.record(:foo, :baz, 1, 2)

    expect(recorded?(:foo, :bar, 1, Bogus::Anything)).to be_false
  end
end
