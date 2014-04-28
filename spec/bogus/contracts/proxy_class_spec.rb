require 'spec_helper'

describe Bogus::ProxyClass do
  module SampleModule
    class GrandLibrary
      SAMPLE_CONSTANT = "foo"

      def checkout(book, user)
        :checkouted
      end

      def self.find_by_address(address)
        :the_library
      end

      def self.find_by_isbn(isbn)
        raise StandardError
      end
    end
  end

  let(:proxy_class) { Bogus::ProxyClass.new(:fake_name, SampleModule::GrandLibrary, create_recording_proxy) }

  let(:create_recording_proxy) do
    lambda {|instance, fake_name| Bogus::RecordingProxy.new(instance, fake_name, interactions_repository) }
  end

  let(:interactions_repository) { FakeRepository.new }

  it "returns the proxy" do
    expect(proxy_class.new.checkout("Moby Dick", "Bob")).to eq :checkouted
  end

  it "records interactions with created objects" do
    proxy_class.new.checkout("Moby Dick", "Bob")

    expect(interactions_repository).to have_recorded(:fake_name, :checkout, "Moby Dick", "Bob")
  end

  it "responds to every method that the original class responds to" do
    expect(proxy_class).to respond_to(:find_by_address)
  end

  it "delegates interactions with the proxy class to wrapped class" do
    expect(proxy_class.find_by_address("some address")).to eq :the_library
  end

  it "records interactions with the proxy class" do
    proxy_class.find_by_address("some address")

    expect(interactions_repository).to have_recorded(:fake_name, :find_by_address, "some address")
  end

  it "records return values" do
    proxy_class.find_by_address("some address")

    expect(interactions_repository.return_value(:fake_name, :find_by_address, "some address")).to eq :the_library
  end

  it "re-raises exceptions" do
    expect {
      proxy_class.find_by_isbn("some isbn")
    }.to raise_error(StandardError)
  end

  it "records raised exceptions" do
    proxy_class.find_by_isbn("some isbn") rescue nil

    expect {
      interactions_repository.return_value(:fake_name, :find_by_isbn, "some isbn")
    }.to raise_error(StandardError)
  end

  it "allows accessing the constants defined on proxied class" do
    expect(proxy_class::SAMPLE_CONSTANT).to eq "foo"
  end

  class FakeRepository
    def initialize
      @recordings = []
    end

    def record(fake_name, method, *args, &block)
      @recordings << [fake_name, method, args, block]
    end

    def has_recorded?(fake_name, method, *args)
      !!find(fake_name, method, *args)
    end

    def return_value(fake_name, method, *args)
      find(fake_name, method, *args).last.call
    end

    def find(fake_name, method, *args)
      @recordings.find do |f, m, a, b|
        [f, m, a] == [fake_name, method, args]
      end
    end
  end
end
