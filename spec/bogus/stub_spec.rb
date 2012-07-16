require 'spec_helper'

describe Bogus::Stub do
  let(:rr_proxy) { stub }
  let(:rr_stub) { stub }
  let(:verifies_stub_definition) { stub }
  let(:records_stub_interactions) { stub }

  let(:object) { "strings have plenty of methods to call" }

  def new_stub(object)
    Bogus::Stub.new(object, rr_proxy, verifies_stub_definition, records_stub_interactions)
  end

  before do
    stub(rr_proxy).stub{ rr_stub }
    stub(verifies_stub_definition).verify!
    stub(records_stub_interactions).record
    stub(rr_stub).method_name
  end

  it "creates stubs with rr" do
    new_stub(object)

    rr_proxy.should have_received.stub(object)
  end

  it "verifies that stub definition matches the real definition" do
    new_stub(object).method_name(:foo, :bar)

    verifies_stub_definition.should have_received.verify!(object, :method_name, [:foo, :bar])
  end

  it "records the stub interaction so that it can be verified later" do
    new_stub(object).method_name(:foo, :bar)

    records_stub_interactions.should have_received.record(object, :method_name, [:foo, :bar])
  end


  it "proxies the method call" do
    new_stub(object).method_name(:foo, :bar)

    rr_stub.should have_received.method_name(:foo, :bar)
  end
end
