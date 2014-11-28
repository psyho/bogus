require 'spec_helper'

describe Bogus::RegistersCreatedFakes do
  let(:fake_registry) { double }
  let(:creates_fakes) { double }
  let(:double_tracker) { double }

  let(:registers_created_fakes) { isolate(Bogus::RegistersCreatedFakes) }

  before do
    allow(fake_registry).to receive(:store)
    allow(creates_fakes).to receive(:create) { :the_fake }
    allow(double_tracker).to receive(:track).with(:the_fake)
  end

  it "registers the fakes created by creates_fakes" do
    registers_created_fakes.create(:foo, as: :instance) { Object }

    expect(fake_registry).to have_received(:store).with(:foo, :the_fake)
  end

  it "tracks the created fakes for purposes of mock expectations" do
    registers_created_fakes.create(:foo, as: :instance) { Object }

    expect(double_tracker).to have_received(:track).with(:the_fake)
  end

  it "returns the created fake" do
    fake = registers_created_fakes.create(:foo, as: :instance) { Object }

    expect(fake).to eq :the_fake
  end
end
