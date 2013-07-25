require 'spec_helper'

describe Bogus::ResetsOverwrittenClasses do
  let(:classes) { [['Foo', :foo], ['Bar', :bar]] }
  let(:overwritten_classes) { stub }
  let(:overwrites_classes) { stub }

  let(:resets_overwritten_classes) { isolate(Bogus::ResetsOverwrittenClasses) }

  before do
    stub(overwritten_classes).classes { classes }
    stub(overwritten_classes).clear
    stub(overwrites_classes).overwrite

    resets_overwritten_classes.reset
  end

  it "overwrites back all of the overwritten classes" do
    overwrites_classes.should have_received.overwrite('Foo', :foo)
    overwrites_classes.should have_received.overwrite('Bar', :bar)
  end

  it "clears the overwritten classes" do
    overwritten_classes.should have_received.clear
  end
end
