require 'spec_helper'

if RubyFeatures.keyword_arguments?
  describe "Ruby 2.0 keyword arguments" do
    class ExampleForKeywordArgs
      eval "def foo(x: 1); end"
      eval "def bar(x: 1, **rest); end"
    end

    include Bogus::MockingDSL

    context "with regular objects" do
      subject { ExampleForKeywordArgs.new }

      it "allows calling the method without the optional keyword args" do
        stub(subject).foo(any_args)

        subject.foo

        expect(subject).to have_received.foo
      end

      include_examples "stubbing methods with keyword arguments"
      include_examples "stubbing methods with double splat"
    end

    context "with fakes" do
      subject { fake(:example_for_keyword_args) }

      it "allows spying without stubbing" do
        subject.foo(x: "test")

        expect(subject).to have_received.foo(x: "test")
      end

      it "allows calling the method without the optional keyword args" do
        subject.foo

        expect(subject).to have_received.foo
      end

      include_examples "stubbing methods with keyword arguments"
      include_examples "stubbing methods with double splat"
    end
  end
end
