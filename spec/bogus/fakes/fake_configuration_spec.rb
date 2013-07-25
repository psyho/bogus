require 'spec_helper'

describe Bogus::FakeConfiguration do
  let(:config) { Bogus::FakeConfiguration.new }

  it "does not contain not configured fakes" do
    config.include?(:foo).should be_false
  end

  def class_block(name)
    config.get(name).class_block
  end

  def opts(name)
    config.get(name).opts
  end

  def stubs(name)
    config.get(name).stubs
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

    opts(:foo).should == {as: :class}
    stubs(:foo).should == {bar: "the bar"}
    class_block(:foo).call.should == Samples::Foo
  end

  context "with no class" do
    it "does not return any class block" do
      config.evaluate do
        fake(:foo, as: :class) { bar "bar" }
      end

      opts(:foo).should == {as: :class}
      stubs(:foo).should == {bar: "bar"}
      class_block(:foo).should be_nil
    end
  end

  context "with no options" do
    it "does not return any options" do
      config.evaluate do
        fake(:foo) { bar "bar" }
      end

      opts(:foo).should == {}
      stubs(:foo).should == {bar: "bar"}
      class_block(:foo).should be_nil
    end
  end

  context "with block return value definitions" do
    it "returns the values, not blocks" do
      config.evaluate do
        fake(:foo) { bar {"bar"} }
      end

      stubs(:foo)[:bar].call.should == "bar"
    end

    it "does not evaluate the blocks when getting, nor when setting" do
      config.evaluate do
        fake(:foo) { bar { raise "gotcha" } }
      end

      block = stubs(:foo)[:bar]
      expect{ block.call }.to raise_error
    end
  end

  context "witn no stubs block" do
    it "returns the options" do
      config.evaluate do
        fake(:foo, as: :class)
      end

      opts(:foo).should == {as: :class}
      stubs(:foo).should == {}
      class_block(:foo).should be_nil
    end
  end
end
