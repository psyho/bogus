require 'spec_helper'

describe Bogus::AddsRecording do
  module SampleModule
    class Library
    end

    class OtherClass
    end
  end

  let(:converts_name_to_class) { stub }
  let(:create_proxy_class) { stub }
  let(:overwrites_classes) { stub }
  let(:overwritten_classes) { stub }

  let(:adds_recording) { isolate(Bogus::AddsRecording) }

  before do
    stub(converts_name_to_class).convert { SampleModule::Library }
    stub(create_proxy_class).call { Object }
    stub(overwrites_classes).overwrite
    stub(overwritten_classes).add
  end

  context "without class argument" do
    before do
      adds_recording.add(:library)
    end

    it "converts the fake name to class" do
      converts_name_to_class.should have_received.convert(:library)
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
      adds_recording.add(:library).should == Object
    end
  end

  context "with class argument" do
    before do
      adds_recording.add(:library, SampleModule::OtherClass)
    end

    it "uses the passed class" do
      converts_name_to_class.should_not have_received.convert(:library)
    end

    it "creates the proxy" do
      create_proxy_class.should have_received.call(:library, SampleModule::OtherClass)
    end

    it "swaps the classes" do
      overwrites_classes.should have_received.overwrite('SampleModule::OtherClass', Object)
    end

    it "records the overwritten class, so that it can be later restored" do
      overwritten_classes.should have_received.add("SampleModule::OtherClass", SampleModule::OtherClass)
    end

    it "returns the proxy class" do
      adds_recording.add(:library, SampleModule::OtherClass).should == Object
    end
  end
end
