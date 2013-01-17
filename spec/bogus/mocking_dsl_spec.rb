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

  class Mocker
    extend Bogus::MockingDSL
  end

  describe "#mock" do
    let(:baz) { Bogus.fake_for(:example_foo) { ExampleFoo } }

    before do
      Mocker.mock(baz).foo("bar") { :return_value }
    end

    it "allows mocking the existing methods" do
      baz.foo("bar").should == :return_value
    end

    it "raises errors when mocks were not called" do
      expect {
        Bogus.ensure_all_expectations_satisfied!
      }.to raise_error(Bogus::NotAllExpectationsSatisfied)
    end

    it "clears the data between tests" do
      Bogus.clear_expectations

      expect {
        Bogus.ensure_all_expectations_satisfied!
      }.not_to raise_error(Bogus::NotAllExpectationsSatisfied)
    end
  end

  describe "#fake" do
    include Bogus::MockingDSL

    it "creates objects that can be stubbed" do
      greeter = fake

      stub(greeter).greet("Jake") { "Hello Jake" }

      greeter.greet("Jake").should == "Hello Jake"
    end

    it "creates objects that can be mocked" do
      greeter = fake

      mock(greeter).greet("Jake") { "Hello Jake" }

      greeter.greet("Jake").should == "Hello Jake"
    end

    it "creates objects with some methods stubbed by default" do
      greeter = fake(greet: "Hello Jake")

      greeter.greet("Jake").should == "Hello Jake"
    end

    it "creates objects that can be spied upon" do
      greeter = fake

      greeter.greet("Jake")

      greeter.should have_received.greet("Jake")
    end

    it "allows chaining interactions" do
      greeter = fake(foo: "bar")

      greeter.baz.foo.should == "bar"
    end
  end
end
