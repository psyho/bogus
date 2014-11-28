require 'spec_helper'

describe Bogus::ResetsStubbedMethods do
  let(:double_tracker) { double }
  let(:overwrites_methods) { double }

  let(:resets_stubbed_methods) { isolate(Bogus::ResetsStubbedMethods) }

  it "resets all stubbed objects back to previous implementation" do
    foo = double
    allow(double_tracker).to receive(:doubles) { [foo] }
    expect(overwrites_methods).to receive(:reset).with(foo)

    resets_stubbed_methods.reset_all_doubles
  end
end
