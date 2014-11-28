require 'spec_helper'

describe Bogus::FakesClasses do
  let(:creates_fakes_with_stubbed_methods) { FakeCreatorOfFakes.new }
  let(:overwrites_classes) { double }
  let(:overwritten_classes) { double }

  let(:fakes_classes) { isolate(Bogus::FakesClasses) }

  module Samples
    class WillBeOverwritten
    end
  end

  before do
    allow(overwrites_classes).to receive(:overwrite)
    allow(overwritten_classes).to receive(:add)
  end

  it "creates a fake named after the class" do
    fakes_classes.fake(Samples::WillBeOverwritten, foo: "bar")

    expect(creates_fakes_with_stubbed_methods).to have_created(:will_be_overwritten,
                                                           {as: :class, foo: "bar"}, Samples::WillBeOverwritten)
  end

  it "overwrites the class with the fake" do
    fake = [:will_be_overwritten, {as: :class}, Samples::WillBeOverwritten]

    fakes_classes.fake(Samples::WillBeOverwritten)

    expect(overwrites_classes).to have_received(:overwrite).with("Samples::WillBeOverwritten", fake)
  end

  it "stores the overwritten class so that it can be replaced back later" do
    fakes_classes.fake(Samples::WillBeOverwritten)

    expect(overwritten_classes).to have_received(:add).with("Samples::WillBeOverwritten", Samples::WillBeOverwritten)
  end

  it "uses the passed fake name if provided" do
    fakes_classes.fake(Samples::WillBeOverwritten, fake_name: :foo_bar)

    expect(creates_fakes_with_stubbed_methods).to have_created(:foo_bar, {as: :class}, Samples::WillBeOverwritten)
  end
end
