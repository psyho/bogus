require 'spec_helper'

describe Bogus::AddsRecording do
  module SampleModule
    class Library
    end

    class OtherClass
    end
  end

  let(:create_proxy_class) { stub }
  let(:overwrites_classes) { stub }
  let(:overwritten_classes) { stub }

  let(:adds_recording) { isolate(Bogus::AddsRecording) }

  before do
    stub(create_proxy_class).call { Object }
    stub(overwrites_classes).overwrite
    stub(overwritten_classes).add
  end

  before do
    adds_recording.add(:library, SampleModule::Library)
  end

  it "creates the proxy" do
    expect(create_proxy_class).to have_received.call(:library, SampleModule::Library)
  end

  it "swaps the classes" do
    expect(overwrites_classes).to have_received.overwrite('SampleModule::Library', Object)
  end

  it "records the overwritten class, so that it can be later restored" do
    expect(overwritten_classes).to have_received.add("SampleModule::Library", SampleModule::Library)
  end

  it "returns the proxy class" do
    expect(adds_recording.add(:library, SampleModule::Library)).to eq Object
  end
end
