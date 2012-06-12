require 'spec_helper'

describe Bogus::VerifiesStubDefinition do
  class ExampleForVerify
    def foo(bar)
    end
  end

  let(:object) { ExampleForVerify.new }
  let(:verifies_stub_definition) { Bogus::VerifiesStubDefinition.new }

  it "checks for method presence" do
    expect do
      verifies_stub_definition.verify!(object, :bar, [1])
    end.to raise_error(Bogus::StubbingNonExistentMethod)
  end

  it "does nothing when definition is fine" do
    expect do
      verifies_stub_definition.verify!(object, :foo, [1])
    end.not_to raise_error
  end

  it "checks the method arity"
end

