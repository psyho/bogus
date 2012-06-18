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
      end.to raise_error(NameError)
    end
  end

  describe "#have_received" do
    context "with a fake object" do
      let(:the_fake) { Bogus.fake_for(:example_foo) }

      it "allows verifying that fakes have correct interfaces" do
        the_fake.foo("test")

        the_fake.should Stubber.have_received.foo("test")
      end

      it "does not allow verifying on non-existent methods" do
        expect {
          the_fake.should Stubber.have_received.bar("test")
        }.to raise_error(NameError)
      end

      it "does not allow verifying on methods with a wrong argument count" do
        expect {
          the_fake.should Stubber.have_received.foo("test", "test 2")
        }.to raise_error(ArgumentError)
      end
    end

    it "can be used with plain old Ruby objects" do
      object = ExampleFoo.new
      stub(object).foo

      object.foo('test')

      object.should Stubber.have_received.foo("test")
    end
  end
end
