require 'spec_helper'

describe Bogus::MockingDSL do
  class ExampleFoo
    def foo(bar)
    end

    def hello(greeting, name)
    end

    def with_optional_args(x, y = 1)
    end

    def self.bar(baz)
      "Hello #{baz}"
    end
  end

  require_relative "./example_foo_kwarg_methods" unless RUBY_VERSION < "2.0"

  class Stubber
    extend Bogus::MockingDSL
  end

  before do
    Bogus.reset!
  end

  describe "#stub" do
    let(:baz) { ExampleFoo.new }

    it "allows stubbing the existing methods" do
      Stubber.stub(baz).foo("bar") { :return_value }

      baz.foo("bar").should == :return_value
    end

    it "can stub method with any parameters" do
      Stubber.stub(baz).foo(Stubber.any_args) { :default_value }
      Stubber.stub(baz).foo("bar") { :foo_value }

      baz.foo("a").should == :default_value
      baz.foo("b").should == :default_value
      baz.foo("bar").should == :foo_value
    end

    it "can stub method with some wildcard parameters" do
      Stubber.stub(baz).hello(Stubber.any_args) { :default_value }
      Stubber.stub(baz).hello("welcome", Stubber.anything) { :greeting_value }

      baz.hello("hello", "adam").should == :default_value
      baz.hello("welcome", "adam").should == :greeting_value
      baz.hello("welcome", "rudy").should == :greeting_value
    end

    it "can stub method with keyword arguments" do
      Stubber.stub(baz).foo_kwarg(bar: "bar") { :return_value }

      baz.foo_kwarg(bar: "bar").should == :return_value
    end unless RUBY_VERSION < "2.0"

    it "does not allow stubbing non-existent methods" do
      baz = ExampleFoo.new
      expect do
        Stubber.stub(baz).does_not_exist("bar") { :return_value }
      end.to raise_error(NameError)
    end

    it "unstubs methods after each test" do
      Stubber.stub(ExampleFoo).bar("John") { "something else" }

      Bogus.after_each_test

      ExampleFoo.bar("John").should == "Hello John"
    end
  end

  describe "#have_received" do
    context "with a fake object" do
      let(:the_fake) { Bogus.fake_for(:example_foo) }

      it "allows verifying that fakes have correct interfaces" do
        the_fake.foo("test")

        the_fake.should Stubber.have_received.foo("test")
      end

      it "allows verifying interfaces with keyword arguments" do
        the_fake.foo_kwarg(bar: "test")

        the_fake.should Stubber.have_received.foo_kwarg(bar: "test")
      end unless RUBY_VERSION < "2.0"

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

      it "allows spying on methods with optional parameters" do
        the_fake.with_optional_args(123)

        the_fake.should Stubber.have_received.with_optional_args(123)
      end
    end

    it "can be used with plain old Ruby objects" do
      object = ExampleFoo.new
      Stubber.stub(object).foo(Stubber.any_args)

      object.foo('test')

      object.should Stubber.have_received.foo("test")
    end

    it "can be used with keyword arguments" do
      object = ExampleFoo.new
      Stubber.stub(object).foo_kwarg(Stubber.any_args)

      object.foo_kwarg(bar: "test")

      object.should Stubber.have_received.foo_kwarg(bar: "test")
    end unless RUBY_VERSION < "2.0"

    it "allows spying on methods with optional parameters" do
      object = ExampleFoo.new
      Stubber.stub(object).with_optional_args(123) { 999 }

      object.with_optional_args(123).should == 999

      object.should Stubber.have_received.with_optional_args(123)
    end

    class ClassWithMatches
      def matches?(something)
      end
    end

    it "can be used with objects that have same methods as an RSpec expectation" do
      fake = Bogus.fake_for(:class_with_matches)

      fake.matches?("foo")

      fake.should Bogus.have_received.matches?("foo")
    end

    class PassesSelfToCollaborator
      def hello(example)
        example.foo(self)
      end
    end

    it "can be used with self references" do
      Bogus.record_calls_for(:passes_self_to_collaborator)

      fake = Bogus.fake_for(:example_foo)
      object = PassesSelfToCollaborator.new

      object.hello(fake)

      fake.should Bogus.have_received.foo(object)
    end
  end

  class Mocker
    extend Bogus::MockingDSL
  end

  describe "#mock" do
    let(:object) { ExampleFoo.new }
    let(:fake) { Bogus.fake_for(:example_foo) { ExampleFoo } }

    shared_examples_for "mocking dsl" do
      it "allows mocking on methods with optional parameters" do
        Mocker.mock(baz).with_optional_args(1) { :return }

        baz.with_optional_args(1).should == :return

        expect { Bogus.after_each_test }.not_to raise_error
      end

      it "allows mocking on methods with optional keyword arguments" do
        Mocker.mock(baz).with_optional_kwargs(x: 1) { :return }

        baz.with_optional_kwargs(x: 1).should == :return

        expect { Bogus.after_each_test }.not_to raise_error
      end unless RUBY_VERSION < "2.0"

      it "allows mocking with anything" do
        Mocker.mock(baz).hello(1, Bogus::Anything) { :return }

        baz.hello(1, 2).should == :return

        expect { Bogus.after_each_test }.not_to raise_error
      end

      it "allows mocking the existing methods" do
        Mocker.mock(baz).foo("bar") { :return_value }

        baz.foo("bar").should == :return_value

        expect { Bogus.after_each_test }.not_to raise_error
      end

      it "verifies that the methods mocked exist" do
        expect {
          Mocker.mock(baz).does_not_exist { "whatever" }
        }.to raise_error(NameError)
      end

      it "raises errors when mocks were not called" do
        Mocker.mock(baz).foo("bar")

        expect {
          Bogus.after_each_test
        }.to raise_error(Bogus::NotAllExpectationsSatisfied)
      end

      it "clears the data between tests" do
        Mocker.mock(baz).foo("bar")

        Bogus.send(:clear_expectations)

        expect {
          Bogus.after_each_test
        }.not_to raise_error(Bogus::NotAllExpectationsSatisfied)
      end
    end

    class ExampleForMockingOnConstants
      def self.bar(foo)
      end

      def self.baz
      end
    end

    it "clears expected interactions from constants" do
      Mocker.mock(ExampleForMockingOnConstants).bar("foo")

      expect {
        Bogus.after_each_test
      }.to raise_error(Bogus::NotAllExpectationsSatisfied)

      Mocker.stub(ExampleForMockingOnConstants).baz

      expect {
        Bogus.after_each_test
      }.not_to raise_error(Bogus::NotAllExpectationsSatisfied)
    end

    context "with fakes" do
      it_behaves_like "mocking dsl" do
        let(:baz) { fake }
      end
    end

    context "with regular objects" do
      it_behaves_like "mocking dsl" do
        let(:baz) { object }
      end
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

  class SampleOfConfiguredFake
    def self.foo(x)
    end

    def self.bar(x, y)
    end

    def self.baz
    end
  end

  describe "globally configured fakes" do
    before do
      Bogus.fakes do
        fake(:globally_configured_fake, as: :class, class: proc{SampleOfConfiguredFake}) do
          foo "foo"
          bar { "bar" }
          baz { raise "oh noes!" }
        end
      end
    end

    it "returns configured fakes" do
      the_fake = Stubber.fake(:globally_configured_fake)

      the_fake.foo('a').should == "foo"
      the_fake.bar('a', 'b').should == "bar"
    end

    it "allows overwriting stubbed methods" do
      the_fake = Stubber.fake(:globally_configured_fake, bar: "baz")

      the_fake.foo('a').should == "foo"
      the_fake.bar('a', 'b').should == "baz"
    end

    it "evaluates the block passed to method in configuration when method is called" do
      the_fake = Stubber.fake(:globally_configured_fake)

      expect{ the_fake.baz }.to raise_error("oh noes!")
    end
  end

  describe "faking classes" do
    class ThisClassWillBeReplaced
      def self.hello(name)
        "Hello, #{name}"
      end
    end
    TheOriginalClass = ThisClassWillBeReplaced

    after do
      Bogus.reset_overwritten_classes
    end

    it "replaces the class for the duration of the test" do
      Stubber.fake_class(ThisClassWillBeReplaced, hello: "replaced!")

      ThisClassWillBeReplaced.hello("foo").should == "replaced!"
      ThisClassWillBeReplaced.should_not equal(TheOriginalClass)
    end

    it "makes it possible to spy on classes" do
      Stubber.fake_class(ThisClassWillBeReplaced)

      ThisClassWillBeReplaced.hello("foo")

      ThisClassWillBeReplaced.should Bogus.have_received.hello("foo")
      ThisClassWillBeReplaced.should_not Bogus.have_received.hello("bar")
    end

    it "restores the class after the test has finished" do
      Stubber.fake_class(ThisClassWillBeReplaced)
      Bogus.reset_overwritten_classes

      ThisClassWillBeReplaced.should equal(TheOriginalClass)
    end
  end

  class SampleForContracts
    def initialize(name)
      @name = name
    end

    def greet(greeting = "Hello")
      "#{greeting}, #{@name}!"
    end
  end

  describe "contracts" do
    let(:sample) { SampleForContracts.new("John") }

    before do
      Bogus.reset!

      Stubber.fake(:sample_for_contracts, greet: "Welcome, John!")

      Bogus.after_each_test

      Bogus.record_calls_for(:sample_for_contracts)
    end

    it "passes when all the mocked interactions were executed" do
      sample.greet("Welcome").should == "Welcome, John!"

      Bogus.after_each_test

      expect {
        Bogus.verify_contract!(:sample_for_contracts)
      }.not_to raise_error
    end

    it "fails when contracts are fullfilled" do
      sample.greet("Hello").should == "Hello, John!"

      Bogus.after_each_test

      expect {
        Bogus.verify_contract!(:sample_for_contracts)
      }.to raise_error(Bogus::ContractNotFulfilled)
    end
  end
end
