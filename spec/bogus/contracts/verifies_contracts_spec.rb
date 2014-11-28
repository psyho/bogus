require 'spec_helper'

describe Bogus::VerifiesContracts do
  let(:real_interactions) { double }
  let(:doubled_interactions) { double }
  let(:verifies_contracts) { isolate(Bogus::VerifiesContracts) }

  let(:matched_interaction) { interaction("matched") }

  it "fails unmatched calls" do
    first_interaction = interaction("first")
    second_interaction = interaction("second")
    other_interaction = interaction("other")

    allow(doubled_interactions).to receive(:for_fake).with(:fake_name){[first_interaction, matched_interaction, second_interaction]}
    allow(real_interactions).to receive(:for_fake).with(:fake_name){[matched_interaction, other_interaction]}

    allow(real_interactions).to receive(:recorded?).with(:fake_name, first_interaction) { false }
    allow(real_interactions).to receive(:recorded?).with(:fake_name, second_interaction) { false }
    allow(real_interactions).to receive(:recorded?).with(:fake_name, matched_interaction) { true }

    expect_verify_to_raise_error_with_interactions(:fake_name,
                                                   [first_interaction, second_interaction],
                                                   [matched_interaction, other_interaction])
  end

  it "passes with all calls matched" do
    allow(doubled_interactions).to receive(:for_fake).with(:fake_name) { [matched_interaction] }
    allow(real_interactions).to receive(:recorded?).with(:fake_name, matched_interaction) { true }

    expect {
      verifies_contracts.verify(:fake_name)
    }.not_to raise_error
  end

  def expect_verify_to_raise_error_with_interactions(name, missed, real)
    verifies_contracts.verify(name)
    fail
  rescue Bogus::ContractNotFulfilled => contract_error
    expect(contract_error.fake_name).to eq name
    expect(contract_error.missed_interactions).to eq missed
    expect(contract_error.actual_interactions).to eq real
  end

  def interaction(method)
    Bogus::Interaction.new(method, [:foo, :bar]) { "return value" }
  end
end
