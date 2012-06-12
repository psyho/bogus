require 'spec_helper'

describe Bogus::CreatesStubs do
  let(:rr_proxy) { stub }
  let(:verifies_stub_definition) { stub }
  let(:creates_stubs) { Bogus::CreatesStubs.new(rr_proxy, verifies_stub_definition) }

  it "creates stubs" do
    object = stub
    Bogus::Stub.should_receive(:new).with(object, rr_proxy, verifies_stub_definition).and_return(:the_stub)

    creates_stubs.create(object).should == :the_stub
  end
end
