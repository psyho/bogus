require 'spec_helper'

describe Bogus::RegistersCreatedFakes do
  let(:fake_registry) { stub }
  let(:creates_fakes) { stub }
  let(:double_tracker) { stub }

  let(:registers_created_fakes) { isolate(Bogus::RegistersCreatedFakes) }

  before do
    stub(fake_registry).store
    stub(creates_fakes).create { :the_fake }
    stub(double_tracker).track(:the_fake)
  end

  it "registers the fakes created by creates_fakes" do
    registers_created_fakes.create(:foo, as: :instance) { Object }

    fake_registry.should have_received.store(:foo, :the_fake)
  end

  it "tracks the created fakes for purposes of mock expectations" do
    registers_created_fakes.create(:foo, as: :instance) { Object }

    double_tracker.should have_received.track(:the_fake)
  end

  it "returns the created fake" do
    fake = registers_created_fakes.create(:foo, as: :instance) { Object }

    fake.should == :the_fake
  end
end
