require 'spec_helper'

describe Bogus::VerifiesStubDefinition do
  class ExampleForVerify
    def initialize(test)

    end
    def foo(bar)
    end

    def three_args(x, y, z)
    end

    def optional_args(x, y = 1, z = 2)
    end

    def var_args(x, *y)
    end
  end

  let(:object) { ExampleForVerify.new(1) }
  let(:verifies_stub_definition) { Bogus::VerifiesStubDefinition.new(method_stringifier) }
  let(:method_stringifier) { isolate(Bogus::MethodStringifier) }

  def verify(method_name, args)
    verifies_stub_definition.verify!(object, method_name, args)
  end

  def it_allows(method_name, args)
    expect{ verify(method_name, args) }.not_to raise_error
  end

  def it_disallows(method_name, args, error = ArgumentError)
    expect{ verify(method_name, args) }.to raise_error(error)
  end

  def self.it_allows_argument_numbers(method_name, *arg_counts)
    arg_counts.each do |arg_count|
      it "allows #{arg_count} arguments" do
        it_allows(method_name, [1] * arg_count)
      end
    end
  end

  def self.it_disallows_argument_numbers(method_name, *arg_counts)
    arg_counts.each do |arg_count|
      it "disallows #{arg_count} arguments" do
        it_disallows(method_name, [1] * arg_count)
      end
    end
  end

  context "when checking #new" do
    let(:object) { ExampleForVerify }
    it "checks arity" do
      it_allows(:new, [1])
    end
    it "errors with the wrong number of arguments" do
      it_disallows(:new, [])
    end
  end

  it "checks for method presence" do
    it_disallows(:bar, [1], NameError)
  end

  it "allows interactions that use any_args" do
    it_allows(:three_args, [Bogus::AnyArgs])
  end

  describe "method arity checks" do
    context "method with positive arity" do
      it_allows_argument_numbers :three_args, 3
      it_disallows_argument_numbers :three_args, 2, 4
    end

    context "method with optional arguments" do
      it_allows_argument_numbers :optional_args, 1, 2, 3
      it_disallows_argument_numbers :optional_args, 0, 4
    end

    context "method with infinite number of arguments" do
      it_allows_argument_numbers :var_args, 1000
      it_disallows_argument_numbers :var_args, 0
    end
  end

  class UsesMethodMissing
    def respond_to?(method)
      method == :foo
    end

    def method_missing(name, *args, &block)
      return super unless name == :foo
      :bar
    end
  end

  context "with objects that use method missing" do
    let(:object) { UsesMethodMissing.new }

    it "allows stubbing methods that the object responds to" do
      it_allows(:foo, [])
    end

    it "disallows stubbing methods that the object does not respond to" do
      it_disallows(:bar, [], NameError)
    end
  end
end

