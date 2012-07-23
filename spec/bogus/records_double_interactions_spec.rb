require 'spec_helper'

describe Bogus::RecordsDoubleInteractions do
  let(:fake_registry) { stub }
  let(:doubled_interactions) { stub }
  let(:object) { Object.new }

  let(:records_double_interactions) { isolate(Bogus::RecordsDoubleInteractions) }

  it "records the call in double interaction repository" do
    stub(fake_registry).name(object) { :object_name }
    stub(doubled_interactions).record

    records_double_interactions.record(object, :method_name, [:foo, 1])

    doubled_interactions.should have_received.record(:object_name, :method_name, :foo, 1)
  end

  it "does not record the interaction if object is not a fake" do
    stub(fake_registry).name(object) { nil }
    dont_allow(doubled_interactions).record

    records_double_interactions.record(object, :method_name, [:foo, 1])
  end
end
