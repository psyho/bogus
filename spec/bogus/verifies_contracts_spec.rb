require 'spec_helper'

describe Bogus::VerifiesContracts, pending: "work in progress" do
  it "verifies the contract" do
    stubbed_interactions = stub
    real_interactions = stub

    verifies_contracts = Bogus::VerifiesContracts.new(stubbed_interactions, real_interactions)

    stub(real_interactions).for_fake(:fake_name) { [[:method, 1, 2, 3]] }

    stubbed_interactions.recorded?(:fake_name, :method, 1, 2, 3)
  end
end
