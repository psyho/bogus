require 'spec_helper'

describe Bogus::RecordsDoubleInteractions do
  let(:fake_registry) { double }
  let(:doubled_interactions) { double }
  let(:object) { Object.new }

  let(:records_double_interactions) { isolate(Bogus::RecordsDoubleInteractions) }

  it "records the call in double interaction repository" do
    allow(fake_registry).to receive(:name).with(object) { :object_name }
    allow(doubled_interactions).to receive(:record)

    records_double_interactions.record(object, :method_name, [:foo, 1])

    expect(doubled_interactions).to have_received(:record).with(:object_name, :method_name, :foo, 1)
  end

  it "does not record the interaction if object is not a fake" do
    allow(fake_registry).to receive(:name).with(object) { nil }
    allow(doubled_interactions).to receive(:record)

    records_double_interactions.record(object, :method_name, [:foo, 1])

    expect(doubled_interactions).not_to have_received(:record)
  end
end
