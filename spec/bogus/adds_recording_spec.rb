require 'spec_helper'

describe Bogus::AddsRecording do
  module SampleModule
    class Library
    end
  end

  let(:converts_name_to_class) { stub }
  let(:create_proxy_class) { stub }
  let(:overwrites_classes) { stub }
  let(:adds_recording) { Bogus::AddsRecording.new(converts_name_to_class, create_proxy_class, overwrites_classes) }

  before do
    stub(converts_name_to_class).convert { SampleModule::Library }
    stub(create_proxy_class).call { Object }
    stub(overwrites_classes).overwrite

    adds_recording.add(:library)
  end

  it "converts the fake name to class" do
    converts_name_to_class.should have_received.convert(:library)
  end

  it "creates the proxy" do
    create_proxy_class.should have_received.call(:library, SampleModule::Library)
  end

  it "swaps the classes" do
    overwrites_classes.should have_received.overwrite(SampleModule::Library, Object)
  end
end
