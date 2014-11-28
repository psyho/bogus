require 'spec_helper'

describe Bogus::ResetsOverwrittenClasses do
  let(:classes) { [['Foo', :foo], ['Bar', :bar]] }
  let(:overwritten_classes) { double }
  let(:overwrites_classes) { double }

  let(:resets_overwritten_classes) { isolate(Bogus::ResetsOverwrittenClasses) }

  before do
    allow(overwritten_classes).to receive(:classes) { classes }
    allow(overwritten_classes).to receive(:clear)
    allow(overwrites_classes).to receive(:overwrite)

    resets_overwritten_classes.reset
  end

  it "overwrites back all of the overwritten classes" do
    expect(overwrites_classes).to have_received(:overwrite).with('Foo', :foo)
    expect(overwrites_classes).to have_received(:overwrite).with('Bar', :bar)
  end

  it "clears the overwritten classes" do
    expect(overwritten_classes).to have_received(:clear)
  end
end
