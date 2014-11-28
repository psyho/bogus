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

      expect(baz.foo("bar")).to eq :return_value
    end

    it "can stub method with any parameters" do
      Stubber.stub(baz).foo(Stubber.any_args) { :default_value }
      Stubber.stub(baz).foo("bar") { :foo_value }

      expect(baz.foo("a")).to eq :default_value
      expect(baz.foo("b")).to eq :default_value
      expect(baz.foo("bar")).to eq :foo_value
    end

    it "can stub method with some wildcard parameters" do
      Stubber.stub(baz).hello(Stubber.any_args) { :default_value }
      Stubber.stub(baz).hello("welcome", Stubber.anything) { :greeting_value }

      expect(baz.hello("hello", "adam")).to eq :default_value
      expect(baz.hello("welcome", "adam")).to eq :greeting_value
      expect(baz.hello("welcome", "rudy")).to eq :greeting_value
    end

    it "does not allow stubbing non-existent methods" do
      baz = ExampleFoo.new
      expect do
        Stubber.stub(baz).does_not_exist("bar") { :return_value }
      end.to raise_error(NameError)
    end

    it "unstubs methods after each test" do
      Stubber.stub(ExampleFoo).bar("John") { "something else" }

      Bogus.after_each_test

      expect(ExampleFoo.bar("John")).to eq "Hello John"
    end
  end

  describe "#have_received" do
    context "with a fake object" do
      let(:the_fake) { Bogus.fake_for(:example_foo) }

      it "allows verifying that fakes have correct interfaces" do
        the_fake.foo("test")

        expect(the_fake).to Stubber.have_received.foo("test")
      end

      it "does not allow verifying on non-existent methods" do
        expect {
          expect(the_fake).to Stubber.have_received.bar("test")
        }.to raise_error(NameError)
      end

      it "does not allow verifying on methods with a wrong argument count" do
        expect {
          expect(the_fake).to Stubber.have_received.foo("test", "test 2")
        }.to raise_error(ArgumentError)
      end

      it "allows spying on methods with optional parameters" do
        the_fake.with_optional_args(123)

        expect(the_fake).to Stubber.have_received.with_optional_args(123)
      end
    end

    it "can be used with plain old Ruby objects" do
      object = ExampleFoo.new
      Stubber.stub(object).foo(Stubber.any_args)

      object.foo('test')

      expect(object).to Stubber.have_received.foo("test")
    end

    it "allows spying on methods with optional parameters" do
      object = ExampleFoo.new
      Stubber.stub(object).with_optional_args(123) { 999 }

      expect(object.with_optional_args(123)).to eq 999

      expect(object).to Stubber.have_received.with_optional_args(123)
    end

    class ClassWithMatches
      def matches?(something)
      end
    end

    it "can be used with objects that have same methods as an RSpec expectation" do
      fake = Bogus.fake_for(:class_with_matches)

      fake.matches?("foo")

      expect(fake).to Bogus.have_received.matches?("foo")
    end

    class PassesSelfToCollaborator
      def hello(example)
        example.foo(self)
      end
    end

    it "can be used with self references" do
      Bogus.record_calls_for(:passes_self_to_collaborator, PassesSelfToCollaborator)

      fake = Bogus.fake_for(:example_foo)
      object = PassesSelfToCollaborator.new

      object.hello(fake)

      expect(fake).to Bogus.have_received.foo(object)
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

        expect(baz.with_optional_args(1)).to eq :return

        expect { Bogus.after_each_test }.not_to raise_error
      end

      it "allows mocking with anything" do
        Mocker.mock(baz).hello(1, Bogus::Anything) { :return }

        expect(baz.hello(1, 2)).to eq :return

        expect { Bogus.after_each_test }.not_to raise_error
      end

      it "allows mocking the existing methods" do
        Mocker.mock(baz).foo("bar") { :return_value }

        expect(baz.foo("bar")).to eq :return_value

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
        }.not_to raise_error
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
      }.not_to raise_error
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
    before do
      extend Bogus::MockingDSL
    end

    it "creates objects that can be stubbed" do
      greeter = fake

      stub(greeter).greet("Jake") { "Hello Jake" }

      expect(greeter.greet("Jake")).to eq "Hello Jake"
    end

    it "creates objects that can be mocked" do
      greeter = fake

      mock(greeter).greet("Jake") { "Hello Jake" }

      expect(greeter.greet("Jake")).to eq "Hello Jake"
    end

    it "creates objects with some methods stubbed by default" do
      greeter = fake(greet: "Hello Jake")

      expect(greeter.greet("Jake")).to eq "Hello Jake"
    end

    it "creates objects that can be spied upon" do
      greeter = fake

      greeter.greet("Jake")

      expect(greeter).to have_received.greet("Jake")
      expect(greeter).to_not have_received.greet("Bob")
    end

    it "verifies mock expectations set on anonymous fakes" do
      greeter = fake
      mock(greeter).greet("Jake") { "Hello Jake" }

      expect {
        Bogus.after_each_test
      }.to raise_error(Bogus::NotAllExpectationsSatisfied)
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

      expect(the_fake.foo('a')).to eq "foo"
      expect(the_fake.bar('a', 'b')).to eq "bar"
    end

    it "allows overwriting stubbed methods" do
      the_fake = Stubber.fake(:globally_configured_fake, bar: "baz")

      expect(the_fake.foo('a')).to eq "foo"
      expect(the_fake.bar('a', 'b')).to eq "baz"
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

      expect(ThisClassWillBeReplaced.hello("foo")).to eq "replaced!"
      expect(ThisClassWillBeReplaced).to_not equal(TheOriginalClass)
    end

    it "makes it possible to spy on classes" do
      Stubber.fake_class(ThisClassWillBeReplaced)

      ThisClassWillBeReplaced.hello("foo")

      expect(ThisClassWillBeReplaced).to Bogus.have_received.hello("foo")
      expect(ThisClassWillBeReplaced).to_not Bogus.have_received.hello("bar")
    end

    it "restores the class after the test has finished" do
      Stubber.fake_class(ThisClassWillBeReplaced)
      Bogus.reset_overwritten_classes

      expect(ThisClassWillBeReplaced).to equal(TheOriginalClass)
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

      Bogus.record_calls_for(:sample_for_contracts, SampleForContracts)
    end

    it "passes when all the mocked interactions were executed" do
      expect(sample.greet("Welcome")).to eq "Welcome, John!"

      Bogus.after_each_test

      expect {
        Bogus.verify_contract!(:sample_for_contracts)
      }.not_to raise_error
    end

    it "fails when contracts are fullfilled" do
      expect(sample.greet("Hello")).to eq "Hello, John!"

      Bogus.after_each_test

      expect {
        Bogus.verify_contract!(:sample_for_contracts)
      }.to raise_error(Bogus::ContractNotFulfilled)
    end
  end
end
