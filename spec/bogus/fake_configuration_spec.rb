require 'spec_helper'

describe Bogus::FakeConfiguration do
  let(:config) { Bogus::FakeConfiguration.new }

  it "does not contain not configured fakes" do
    config.include?(:foo).should be_false
  end

  it "contains configured fakes" do
    config.evaluate do
      fake(:foo, as: :class, class: proc{Samples::Foo}) do
        bar "the bar"
      end
    end

    config.include?(:foo).should be_true
    config.include?(:bar).should be_false
  end

  it "returns the configuration for a fake" do
    config.evaluate do
      fake(:foo, as: :class, class: proc{Samples::Foo}) do
        bar "the bar"
      end
    end

    opts, return_block = config.get(:foo)
    opts.should == {as: :class, bar: "the bar"}
    return_block.call.should == Samples::Foo
  end

  context "with no class" do
    it "does not return any class block" do
      config.evaluate do
        fake(:foo, as: :class) { bar "bar" }
      end

      config.get(:foo).should == [{as: :class, bar: "bar"}, nil]
    end
  end

  context "with no options" do
    it "does not return any options" do
      config.evaluate do
        fake(:foo) { bar "bar" }
      end

      config.get(:foo).should == [{bar: "bar"}, nil]
    end
  end

  context "with block return value definitions" do
    it "returns the values, not blocks" do
      config.evaluate do
        fake(:foo) { bar {"bar"} }
      end

      config.get(:foo).should == [{bar: "bar"}, nil]
    end

    it "evaluates the blocks when getting, not when setting" do
      config.evaluate do
        fake(:foo) { bar { raise "gotcha" } }
      end

      expect{ config.get(:foo) }.to raise_error
    end
  end

  context "witn no stubs block" do
    it "returns the options" do
      config.evaluate do
        fake(:foo, as: :class)
      end

      config.get(:foo).should == [{as: :class}, nil]
    end
  end
end
