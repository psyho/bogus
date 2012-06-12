require 'spec_helper'

describe Bogus::MockingDSL do
  class ExampleFoo
    def foo(bar)
    end
  end

  class Stubber
    extend Bogus::MockingDSL
  end

  describe "#stub" do
    it "allows stubbing the existing methods" do
      baz = ExampleFoo.new

      Stubber.stub(baz).foo("bar") { :return_value }

      baz.foo("bar").should == :return_value
    end

    it "does not allow stubbing non-existent methods" do
      baz = ExampleFoo.new
      expect do
        Stubber.stub(baz).does_not_exist("bar") { :return_value }
      end.to raise_error(Bogus::StubbingNonExistentMethod)
    end
  end
end
