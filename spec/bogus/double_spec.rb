require 'spec_helper'

describe Bogus::Double do
  let(:rr_double) { stub }
  let(:verifies_stub_definition) { stub }
  let(:records_double_interactions) { stub }

  let(:object) { "strings have plenty of methods to call" }

  let(:bogus_double) { isolate(Bogus::Double, double: rr_double) }

  before do
    stub(verifies_stub_definition).verify!
    stub(records_double_interactions).record
    stub(rr_double).method_name

    bogus_double.method_name(:foo, :bar)
  end

  it "verifies that stub definition matches the real definition" do
    verifies_stub_definition.should have_received.verify!(object, :method_name, [:foo, :bar])
  end

  it "records the stub interaction so that it can be verified later" do
    records_double_interactions.should have_received.record(object, :method_name, [:foo, :bar])
  end

  it "proxies the method call" do
    rr_double.should have_received.method_name(:foo, :bar)
  end
end
