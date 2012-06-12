require 'spec_helper'

describe Bogus::Stub do
  let(:rr_proxy) { stub }
  let(:rr_stub) { stub }
  let(:verifies_stub_definition) { stub }

  let(:object) { "strings have plenty of methods to call" }

  def new_stub(object)
    Bogus::Stub.new(object, rr_proxy, verifies_stub_definition)
  end

  before do
    rr_proxy.stub(stub: rr_stub)
    verifies_stub_definition.stub(:verify!)
    rr_stub.stub(:method_name)
  end

  it "creates stubs with rr" do
    rr_proxy.should_receive(:stub).with(object).and_return(rr_stub)

    new_stub(object)
  end

  it "verifies that stub definition matches the real definition" do
    verifies_stub_definition.should_receive(:verify!).with(object, :method_name, [:foo, :bar])

    new_stub(object).method_name(:foo, :bar)
  end

  it "proxies the method call" do
    rr_stub.should_receive(:method_name).with(:foo, :bar)

    new_stub(object).method_name(:foo, :bar)
  end
end
