require 'spec_helper'

describe Bogus::FakesClasses do
  let(:creates_fakes_with_stubbed_methods) { FakeCreatorOfFakes.new }
  let(:overwrites_classes) { stub }
  let(:overwritten_classes) { stub }

  let(:fakes_classes) { isolate(Bogus::FakesClasses) }

  module Samples
    class WillBeOverwritten
    end
  end

  before do
    stub(overwrites_classes).overwrite
    stub(overwritten_classes).add
  end

  it "creates a fake named after the class" do
    fakes_classes.fake(Samples::WillBeOverwritten, foo: "bar")

    creates_fakes_with_stubbed_methods.should have_created(:will_be_overwritten,
                                                           {as: :class, foo: "bar"}, Samples::WillBeOverwritten)
  end

  it "overwrites the class with the fake" do
    fake = [:will_be_overwritten, {as: :class}, Samples::WillBeOverwritten]

    fakes_classes.fake(Samples::WillBeOverwritten)

    overwrites_classes.should have_received.overwrite("Samples::WillBeOverwritten", fake)
  end

  it "stores the overwritten class so that it can be replaced back later" do
    fakes_classes.fake(Samples::WillBeOverwritten)

    overwritten_classes.should have_received.add("Samples::WillBeOverwritten", Samples::WillBeOverwritten)
  end

  it "uses the passed fake name if provided" do
    fakes_classes.fake(Samples::WillBeOverwritten, fake_name: :foo_bar)

    creates_fakes_with_stubbed_methods.should have_created(:foo_bar, {as: :class}, Samples::WillBeOverwritten)
  end
end
