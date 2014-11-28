require 'spec_helper'

describe Bogus::AddsRecording do
  module SampleModule
    class Library
    end

    class OtherClass
    end
  end

  let(:create_proxy_class) { double }
  let(:overwrites_classes) { double }
  let(:overwritten_classes) { double }

  let(:adds_recording) { isolate(Bogus::AddsRecording) }

  before do
    allow(create_proxy_class).to receive(:call) { Object }
    allow(overwrites_classes).to receive(:overwrite)
    allow(overwritten_classes).to receive(:add)
  end

  before do
    adds_recording.add(:library, SampleModule::Library)
  end

  it "creates the proxy" do
    expect(create_proxy_class).to have_received(:call).with(:library, SampleModule::Library)
  end

  it "swaps the classes" do
    expect(overwrites_classes).to have_received(:overwrite).with('SampleModule::Library', Object)
  end

  it "records the overwritten class, so that it can be later restored" do
    expect(overwritten_classes).to have_received(:add).with("SampleModule::Library", SampleModule::Library)
  end

  it "returns the proxy class" do
    expect(adds_recording.add(:library, SampleModule::Library)).to eq Object
  end
end
