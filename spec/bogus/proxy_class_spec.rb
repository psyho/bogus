require 'spec_helper'

describe Bogus::ProxyClass do
  module SampleModule
    class GrandLibrary
      def checkout(book, user)
        :checkouted
      end

      def self.find_by_address(address)
        :the_library
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

  it "responds to every method that the original class responds to" do
    proxy_class.should respond_to(:find_by_address)
  end

  it "delegates interactions with the proxy class to wrapped class" do
    proxy_class.find_by_address("some address").should == :the_library
  end

  it "records interactions with the proxy class" do
    proxy_class.find_by_address("some address")

    interactions_repository.should have_received.record(:fake_name, :find_by_address, "some address")
  end
end
