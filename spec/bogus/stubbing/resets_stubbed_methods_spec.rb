require 'spec_helper'

describe Bogus::ResetsStubbedMethods do
  let(:double_tracker) { stub }
  let(:overwrites_methods) { stub }

  let(:resets_stubbed_methods) { isolate(Bogus::ResetsStubbedMethods) }

  it "resets all stubbed objects back to previous implementation" do
    foo = stub
    stub(double_tracker).doubles { [foo] }
    mock(overwrites_methods).reset(foo)

    resets_stubbed_methods.reset_all_doubles
  end
end
