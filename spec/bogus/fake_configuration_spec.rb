require 'spec_helper'

describe Bogus::FakeConfiguration do
  let(:config) { Bogus::FakeConfiguration.new }

  it "does not contain not configured fakes" do
    config.include?(:foo).should be_false
  end

  it "contains configured fakes" do
    config.evaluate do
      foo(as: :class, bar: "the bar") { Samples::Foo }
    end

    config.include?(:foo).should be_true
    config.include?(:bar).should be_false
  end

  it "returns the configuration for a fake" do
    config.evaluate do
      foo(as: :class, bar: "the bar") { Samples::Foo }
    end

    opts, return_block = config.get(:foo)
    opts.should == {as: :class, bar: "the bar"}
    return_block.call.should == Samples::Foo
  end
end
