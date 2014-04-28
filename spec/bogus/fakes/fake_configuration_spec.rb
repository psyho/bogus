require 'spec_helper'

describe Bogus::FakeConfiguration do
  let(:config) { Bogus::FakeConfiguration.new }

  it "does not contain not configured fakes" do
    expect(config.include?(:foo)).to be_false
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

    expect(config.include?(:foo)).to be_true
    expect(config.include?(:bar)).to be_false
  end

  it "returns the configuration for a fake" do
    config.evaluate do
      fake(:foo, as: :class, class: proc{Samples::Foo}) do
        bar "the bar"
      end
    end

    expect(opts(:foo)).to eq ({ as: :class} )
    expect(stubs(:foo)).to eq ({ bar: "the bar"} )
    expect(class_block(:foo).call).to eq Samples::Foo
  end

  context "with no class" do
    it "does not return any class block" do
      config.evaluate do
        fake(:foo, as: :class) { bar "bar" }
      end

      expect(opts(:foo)).to eq ({ as: :class} )
      expect(stubs(:foo)).to eq ({ bar: "bar"} )
      expect(class_block(:foo)).to be_nil
    end
  end

  context "with no options" do
    it "does not return any options" do
      config.evaluate do
        fake(:foo) { bar "bar" }
      end

      expect(opts(:foo)).to eq ({ } )
      expect(stubs(:foo)).to eq ({ bar: "bar"} )
      expect(class_block(:foo)).to be_nil
    end
  end

  context "with block return value definitions" do
    it "returns the values, not blocks" do
      config.evaluate do
        fake(:foo) { bar {"bar"} }
      end

      expect(stubs(:foo)[:bar].call).to eq "bar"
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

      expect(opts(:foo)).to eq ({ as: :class} )
      expect(stubs(:foo)).to eq ({ } )
      expect(class_block(:foo)).to be_nil
    end
  end
end
