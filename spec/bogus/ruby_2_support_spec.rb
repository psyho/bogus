require 'spec_helper'

if RUBY_VERSION >= '2.0'
  describe "Ruby 2.0 keyword arguments" do
    class ExampleForKeywordArgs
      eval "def foo(x: raise, y: 1); end"
    end

    include Bogus::MockingDSL

    shared_examples_for "double interactions" do
      it "can spy on stubbed methods" do
        stub(subject).foo(any_args)

        subject.foo(x: "test")

        subject.should have_received.foo(x: "test")
        subject.should_not have_received.foo(x: "baz")
      end

      it "can mock methods with keyword arguments" do
        mock(subject).foo(x: 1) { :return }

        subject.foo(x: 1).should == :return

        expect { Bogus.after_each_test }.not_to raise_error
      end

      it "can stub methods with keyword arguments" do
        stub(subject).foo(x: "bar") { :return_value }

        subject.foo(x: "bar").should == :return_value
      end

      it "raises on error on unknown keyword" do
        expect {
          stub(subject).foo(x: "bar", baz: "baz")
        }.to raise_error(ArgumentError)
      end

      it "does not overwrite the method signature" do
        stub(subject).foo(x: 1)

        expect {
          subject.foo(bar: 1)
        }.to raise_error(ArgumentError)
      end
    end

    context "with regular objects" do
      subject { ExampleForKeywordArgs.new }

      include_examples "double interactions"
    end

    context "with fakes" do
      subject { fake(:example_for_keyword_args) }

      it "allows spying without stubbing" do
        subject.foo(x: "test")

        subject.should have_received.foo(x: "test")
      end

      include_examples "double interactions"
    end
  end
end
