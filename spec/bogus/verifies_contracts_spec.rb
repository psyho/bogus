require 'spec_helper'

describe Bogus::VerifiesContracts do
  let(:real_interactions) { stub }
  let(:stubbed_interactions) { stub }
  let(:verifies_contracts) { isolate(Bogus::VerifiesContracts) }

  it "fails unmatched calls" do
    stub(stubbed_interactions).for_fake(:fake_name) { [[:method, 1, 2, 3]] }
    stub(real_interactions).recorded?(:fake_name, :method, 1, 2, 3) { false }

    expect {
      verifies_contracts.verify(:fake_name)
    }.to raise_error(Bogus::ContractNotFulfilled)
  end

  it "passes with all calls matched" do
    stub(stubbed_interactions).for_fake(:fake_name) { [[:method, 1, 2, 3]] }
    stub(real_interactions).recorded?(:fake_name, :method, 1, 2, 3) { true }

    expect {
      verifies_contracts.verify(:fake_name)
    }.not_to raise_error
  end
end
