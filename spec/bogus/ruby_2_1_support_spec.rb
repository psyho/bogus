require 'spec_helper'

if RUBY_VERSION >= '2.1'
  describe "Ruby 2.1 required keyword arguments" do
    class ExampleForRequiredKeywordArgs
      eval "def foo(x:); end"
      eval "def bar(x:, **rest); end"
    end

    include Bogus::MockingDSL

    context "with regular objects" do
      subject { ExampleForRequiredKeywordArgs.new }

      it "does not allow calling the method without all required arguments" do
        stub(subject).foo(any_args) { :hello }

        expect{ subject.foo }.to raise_error(ArgumentError)
      end

      include_examples "stubbing methods with keyword arguments"
      include_examples "stubbing methods with double splat"
    end

    context "with fakes" do
      subject { fake(:example_for_required_keyword_args) }

      it "allows spying without stubbing" do
        subject.foo(x: "hello")

        subject.should have_received.foo(x: "hello")
      end

      include_examples "stubbing methods with keyword arguments"
      include_examples "stubbing methods with double splat"
    end
  end
end
