require 'spec_helper'

describe Bogus::FakeRegistry do
  let(:fake_registry) { Bogus::FakeRegistry.new }

  it "knows the fake's names" do
    object = Object.new

    fake_registry.store(:name, object)

    expect(fake_registry.name(object)).to eq :name
  end

  it "returns name based on object identity" do
    example = Struct.new(:id)

    object = example.new(1)
    duplicate = example.new(1)

    fake_registry.store(:object, object)

    expect(fake_registry.name(duplicate)).to be_nil
  end
end
