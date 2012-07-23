require 'spec_helper'

describe Bogus::InvocationMatcher do
  let(:object) { stub }
  let(:method) { nil }
  let(:records_double_interactions) { stub }
  let(:verifies_stub_definition) { stub }

  let(:invocation_matcher) { isolate(Bogus::InvocationMatcher) }

  before do
    stub(verifies_stub_definition).verify!
    stub(records_double_interactions).record

    invocation_matcher.the_method(:foo, :bar)
    invocation_matcher.matches?(object)
  end

  it "verifies stub definition" do
    verifies_stub_definition.should have_received.verify!(object, :the_method, [:foo, :bar])
  end

  it "records double interacions" do
    records_double_interactions.should have_received.record(object, :the_method, [:foo, :bar])
  end
end
