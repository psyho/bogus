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
    create_proxy_class.should have_received.call(:library, SampleModule::Library)
  end

  it "swaps the classes" do
    overwrites_classes.should have_received.overwrite('SampleModule::Library', Object)
  end

  it "records the overwritten class, so that it can be later restored" do
    overwritten_classes.should have_received.add("SampleModule::Library", SampleModule::Library)
  end

  it "returns the proxy class" do
    adds_recording.add(:library, SampleModule::Library).should == Object
  end
end
