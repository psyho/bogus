require 'spec_helper'

describe Bogus::ProxyClass do
  module SampleModule
    class GrandLibrary
      def checkout(book, user)
        :checkouted
      end
    end
  end

  let(:proxy_class) { Bogus::ProxyClass.new(:fake_name, SampleModule::GrandLibrary, create_recording_proxy) }

  let(:create_recording_proxy) do
    lambda {|instance, fake_name| Bogus::RecordingProxy.new(instance, fake_name, interactions_repository) }
  end

  let(:interactions_repository) { stub }

  before do
    stub(interactions_repository).record
  end

  it "returns the proxy" do
    proxy_class.new.checkout("Moby Dick", "Bob").should == :checkouted
  end

  it "records interactions with created objects" do
    proxy_class.new.checkout("Moby Dick", "Bob")

    interactions_repository.should have_received.record(:fake_name, :checkout, "Moby Dick", "Bob")
  end
end
