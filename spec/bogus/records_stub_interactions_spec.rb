require 'spec_helper'

describe Bogus::RecordsStubInteractions do
  let(:fake_registry) { stub }
  let(:stubbed_interactions) { stub }
  let(:object) { Object.new }

  let(:records_stub_interactions) { isolate(Bogus::RecordsStubInteractions) }

  it "records the call in stub interaction repository" do
    stub(fake_registry).name(object) { :object_name }
    stub(stubbed_interactions).record

    records_stub_interactions.record(object, :method_name, [:foo, 1])

    stubbed_interactions.should have_received.record(:object_name, :method_name, :foo, 1)
  end

  it "does not record the interaction if object is not a fake" do
    stub(fake_registry).name(object) { nil }
    dont_allow(stubbed_interactions).record

    records_stub_interactions.record(object, :method_name, [:foo, 1])
  end
end
