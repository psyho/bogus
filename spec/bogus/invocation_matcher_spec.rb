require 'spec_helper'

describe Bogus::InvocationMatcher do
  let(:object) { stub }
  let(:method) { nil }
  let(:records_stub_interactions) { stub }
  let(:verifies_stub_definition) { stub }

  let(:invocation_matcher) { isolate(Bogus::InvocationMatcher) }

  before do
    stub(verifies_stub_definition).verify!
    stub(records_stub_interactions).record

    invocation_matcher.the_method(:foo, :bar)
    invocation_matcher.matches?(object)
  end

  it "verifies stub definition" do
    verifies_stub_definition.should have_received.verify!(object, :the_method, [:foo, :bar])
  end

  it "records stub interacions" do
    records_stub_interactions.should have_received.record(object, :the_method, [:foo, :bar])
  end
end
