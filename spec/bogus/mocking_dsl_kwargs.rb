require 'spec_helper'

describe Bogus::MockingDSL, 'with keyword arguments' do
  class ExampleFooKwargs
    def foo(bar: raise)
    end

    def hello(greeting: raise, name: raise)
    end

    def with_optional_args(x: raise, y: 1)
    end
  end

  class Stubber
    extend Bogus::MockingDSL
  end

  before do
    Bogus.reset!
  end

  describe "#stub" do
    let(:baz) { ExampleFooKwargs.new }

    it "allows stubbing the existing methods" do
      Stubber.stub(baz).foo(bar: "bar") { :return_value }

      baz.foo(bar: "bar").should == :return_value
    end

    it "can stub method with any parameters" do
      Stubber.stub(baz).foo(Stubber.any_args) { :default_value }
      Stubber.stub(baz).foo(bar: "bar") { :foo_value }

      baz.foo(bar: "a").should == :default_value
      baz.foo(bar: "b").should == :default_value
      baz.foo(bar: "bar").should == :foo_value
    end

    it "can stub method with some wildcard parameters" do
      Stubber.stub(baz).hello(Stubber.any_args) { :default_value }
      Stubber.stub(baz).hello(greeting: "welcome", name: Stubber.anything) { :greeting_value }

      baz.hello(greeting: "hello", name: "adam").should == :default_value
      baz.hello(greeting: "welcome", name: "adam").should == :greeting_value
      baz.hello(greeting: "welcome", name: "rudy").should == :greeting_value
    end
  end

  describe "#have_received" do
    context "with a fake object" do
      let(:the_fake) { Bogus.fake_for(:example_foo_kwargs) }

      it "allows verifying that fakes have correct interfaces" do
        the_fake.foo(bar: "test")

        the_fake.should Stubber.have_received.foo(bar: "test")
      end

      it "allows spying on methods with optional parameters" do
        the_fake.with_optional_args(x: 123)

        the_fake.should Stubber.have_received.with_optional_args(x: 123)
      end
    end

    it "can be used with plain old Ruby objects" do
      object = ExampleFooKwargs.new
      Stubber.stub(object).foo(Stubber.any_args)

      object.foo(bar: 'test')

      object.should Stubber.have_received.foo(bar: "test")
    end

    it "allows spying on methods with optional parameters" do
      object = ExampleFooKwargs.new
      Stubber.stub(object).with_optional_args(x: 123) { 999 }

      object.with_optional_args(x: 123).should == 999

      object.should Stubber.have_received.with_optional_args(x: 123)
    end

    class PassesSelfToCollaboratorKwargs
      def hello(example: raise)
        example.foo(bar: self)
      end
    end

    it "can be used with self references" do
      Bogus.record_calls_for(:passes_self_to_collaborator_kwargs)

      fake = Bogus.fake_for(:example_foo_kwargs)
      object = PassesSelfToCollaboratorKwargs.new

      object.hello(example: fake)

      fake.should Bogus.have_received.foo(bar: object)
    end
  end

  class Mocker
    extend Bogus::MockingDSL
  end

  describe "#mock" do
    let(:object) { ExampleFooKwargs.new }
    let(:fake) { Bogus.fake_for(:example_foo_kwargs) { ExampleFooKwargs } }

    shared_examples_for "mocking dsl with kwargs" do
      it "allows mocking on methods with optional parameters" do
        Mocker.mock(baz).with_optional_args(x: 1) { :return }

        baz.with_optional_args(x: 1).should == :return

        expect { Bogus.after_each_test }.not_to raise_error
      end

      it "allows mocking with anything" do
        Mocker.mock(baz).hello(greeting: 1, name: Bogus::Anything) { :return }

        baz.hello(greeting: 1, name: 2).should == :return

        expect { Bogus.after_each_test }.not_to raise_error
      end

      it "allows mocking the existing methods" do
        Mocker.mock(baz).foo(bar: "bar") { :return_value }

        baz.foo(bar: "bar").should == :return_value

        expect { Bogus.after_each_test }.not_to raise_error
      end

      it "raises errors when mocks were not called" do
        Mocker.mock(baz).foo(bar: "bar")

        expect {
          Bogus.after_each_test
        }.to raise_error(Bogus::NotAllExpectationsSatisfied)
      end

      it "clears the data between tests" do
        Mocker.mock(baz).foo(bar: "bar")

        Bogus.send(:clear_expectations)

        expect {
          Bogus.after_each_test
        }.not_to raise_error(Bogus::NotAllExpectationsSatisfied)
      end
    end

    context "with fakes" do
      it_behaves_like "mocking dsl with kwargs" do
        let(:baz) { fake }
      end
    end

    context "with regular objects" do
      it_behaves_like "mocking dsl with kwargs" do
        let(:baz) { object }
      end
    end
  end

  describe "#fake" do
    include Bogus::MockingDSL

    it "creates objects that can be stubbed" do
      greeter = fake

      stub(greeter).greet(arg: "Jake") { "Hello Jake" }

      greeter.greet(arg: "Jake").should == "Hello Jake"
    end

    it "creates objects that can be mocked" do
      greeter = fake

      mock(greeter).greet(arg: "Jake") { "Hello Jake" }

      greeter.greet(arg: "Jake").should == "Hello Jake"
    end

    it "creates objects with some methods stubbed by default" do
      greeter = fake(greet: "Hello Jake")

      greeter.greet(arg: "Jake").should == "Hello Jake"
    end

    it "creates objects that can be spied upon" do
      greeter = fake

      greeter.greet(arg: "Jake")

      greeter.should have_received.greet(arg: "Jake")
    end
  end

  describe "faking classes" do
    class ThisClassWillBeReplaced
      def self.hello(name: raise)
        "Hello, #{name}"
      end
    end
    TheOriginalClassKwargs = ThisClassWillBeReplaced

    after do
      Bogus.reset_overwritten_classes
    end

    it "replaces the class for the duration of the test" do
      Stubber.fake_class(ThisClassWillBeReplaced, hello: "replaced!")

      ThisClassWillBeReplaced.hello(name: "foo").should == "replaced!"
      ThisClassWillBeReplaced.should_not equal(TheOriginalClassKwargs)
    end

    it "makes it possible to spy on classes" do
      Stubber.fake_class(ThisClassWillBeReplaced)

      ThisClassWillBeReplaced.hello(name: "foo")

      ThisClassWillBeReplaced.should Bogus.have_received.hello(name: "foo")
      ThisClassWillBeReplaced.should_not Bogus.have_received.hello(name: "bar")
    end
  end

  class SampleForContractsKwargs
    def initialize(name: raise)
      @name = name
    end

    def greet(greeting: "Hello")
      "#{greeting}, #{@name}!"
    end
  end

  describe "contracts" do
    let(:sample) { SampleForContractsKwargs.new(name: "John") }

    before do
      Bogus.reset!

      Stubber.fake(:sample_for_contracts_kwargs, greet: "Welcome, John!")

      Bogus.after_each_test

      Bogus.record_calls_for(:sample_for_contracts_kwargs)
    end

    it "passes when all the mocked interactions were executed" do
      sample.greet(greeting: "Welcome").should == "Welcome, John!"

      Bogus.after_each_test

      expect {
        Bogus.verify_contract!(:sample_for_contracts_kwargs)
      }.not_to raise_error
    end

    it "fails when contracts are fullfilled" do
      sample.greet(greeting: "Hello").should == "Hello, John!"

      Bogus.after_each_test

      expect {
        Bogus.verify_contract!(:sample_for_contracts_kwargs)
      }.to raise_error(Bogus::ContractNotFulfilled)
    end
  end
end
