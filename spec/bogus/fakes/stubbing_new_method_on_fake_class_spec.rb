require 'spec_helper'

describe "Stubbing .new on fake class" do
  class ExampleForStubbingNew
  end

  include Bogus::MockingDSL

  it "allows stubbing new on a class" do
    fake_class = fake(ExampleForStubbingNew, as: :class)
    stub(fake_class).new { :stubbed_value }

    instance = fake_class.new

    expect(instance).to eq(:stubbed_value)
  end

  it "returns fake instances when nothing is stubbed" do
    fake_class = fake(ExampleForStubbingNew, as: :class)

    instance = fake_class.new

    expect(instance).to be_an_instance_of(fake_class)
  end
end
