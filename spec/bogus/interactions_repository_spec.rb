require 'spec_helper'

describe Bogus::InteractionsRepository do
  let(:interactions_repository) { Bogus::InteractionsRepository.new }

  it "considers the interaction recorded if it was recorded previously" do
    interactions_repository.record(:foo, :bar, 1, 2, 3)

    interactions_repository.recorded?(:foo, :bar, 1, 2, 3).should be_true
  end

  it "does not consider any interactions recorded prior to any recordings" do
    interactions_repository.recorded?(:foo, :bar, 1).should be_false
  end

  it "does not consider the interaction recorded with a different fake name"  do
    interactions_repository.record(:baz, :bar, 1)

    interactions_repository.recorded?(:foo, :bar, 1).should be_false
  end

  it "does not consider the interaction recorded with a different method name" do
    interactions_repository.record(:foo, :baz, 1)

    interactions_repository.recorded?(:foo, :bar, 1).should be_false
  end

  it "does not consider the interaction recorded with different method arguments" do
    interactions_repository.record(:foo, :bar, 1, 2)

    interactions_repository.recorded?(:foo, :bar, 1).should be_false
  end
end
