require 'spec_helper'

describe Bogus::CreatesAnonymousStubs do
  let(:creates_fakes) { FakeCreatorOfFakes.new }
  let(:responds_to_everything) { stub }
  let(:multi_stubber) { stub(stub_all: :stubbed_object) }

  let(:creates_anonymous_stubs) { isolate(Bogus::CreatesAnonymousStubs) }

  context "given symbol as first parameter" do
    let(:fake) { [:fake_object, :foo, {as: :class}, "something"] }

    before do
      creates_anonymous_stubs.create(:foo, bar: 1, as: :class) { "something" }
    end

    it "creates fakes" do
      creates_fakes.fakes.should == [fake]
    end

    it "stubs all the given methods" do
      multi_stubber.should have_received.stub_all(fake, bar: 1)
    end
  end

  context "given hash as first parameter" do
    before do
      creates_anonymous_stubs.create(bar: 1)
    end

    it "does not create fakes" do
      creates_fakes.fakes.should == []
    end

    it "stubs all the given methods" do
      multi_stubber.should have_received.stub_all(responds_to_everything, bar: 1)
    end
  end

  context "given symbol as only parameter" do
    let(:fake) { [:fake_object, :foo, {}, "something"] }

    before do
      creates_anonymous_stubs.create(:foo) { "something" }
    end

    it "creates fakes" do
      creates_fakes.fakes.should == [fake]
    end

    it "stubs all the given methods" do
      multi_stubber.should have_received.stub_all(fake)
    end
  end

  context "with no parameters" do
    before do
      creates_anonymous_stubs.create
    end

    it "does not create fakes" do
      creates_fakes.fakes.should == []
    end

    it "stubs all the given methods" do
      multi_stubber.should have_received.stub_all(responds_to_everything)
    end
  end

  class FakeCreatorOfFakes
    def create(name, opts = {}, &block)
      fakes << [:fake_object, name, opts, block.call]
    end

    def fakes
      @fakes ||= []
    end
  end
end
