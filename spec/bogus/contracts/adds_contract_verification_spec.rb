require 'spec_helper'

describe Bogus::AddsContractVerification do
  class FakeSyntax
    attr_accessor :described_class

    def initialize(described_class = nil)
      @described_class = described_class
    end

    def before(&block)
      @before = block
    end

    def run_before
      instance_eval(&@before)
    end

    def after(&block)
      @after = block
    end

    def run_after
      instance_eval(&@after)
    end

    def after_suite(&block)
      @after_suite = block
    end

    def run_after_suite
      instance_eval(&@after_suite)
    end
  end

  def self.it_verifies_contract_after_suite
    it "verifies the contract in after_suite" do
      syntax.run_after_suite

      expect(verifies_contracts).to have_received.verify(:some_fake)
    end
  end

  class SomeClass
  end

  class ClassGuessedFromFakeName
  end

  let(:overwritten_class) { :the_overwritten_class }

  let(:adds_recording) { stub }
  let(:verifies_contracts) { stub }
  let(:converts_name_to_class) { stub }
  let(:syntax) { FakeSyntax.new(described_class) }

  let(:adds_contract_verification) { isolate(Bogus::AddsContractVerification) }

  before do
    stub(adds_recording).add { overwritten_class }
    stub(verifies_contracts).verify
    stub(converts_name_to_class).convert { ClassGuessedFromFakeName }
  end

  context "with described_class" do
    let(:described_class) { SomeClass }

    before do
      adds_contract_verification.add(:some_fake)
    end

    it "overwrites described_class in before" do
      syntax.run_before

      expect(syntax.described_class).to eq overwritten_class
    end

    it "resets described_class in after" do
      syntax.run_before
      syntax.run_after

      expect(syntax.described_class).to eq SomeClass
    end

    it_verifies_contract_after_suite

    it "adds recording to described_class" do
      syntax.run_before

      expect(adds_recording).to have_received.add(:some_fake, SomeClass)
    end
  end

  class ClassToOverwrite
  end

  context "with a custom class to overwrite" do
    let(:described_class) { SomeClass }

    before do
      adds_contract_verification.add(:some_fake) { ClassToOverwrite }
    end

    it "does not overwrite described_class in before" do
      syntax.run_before

      expect(syntax.described_class).to eq SomeClass
    end

    it "does not change described_class in after" do
      syntax.run_before
      syntax.run_after

      expect(syntax.described_class).to eq SomeClass
    end

    it_verifies_contract_after_suite

    it "adds recording to custom class" do
      syntax.run_before

      expect(adds_recording).to have_received.add(:some_fake, ClassToOverwrite)
    end
  end

  context "with no custom or described class" do
    let(:described_class) { nil }

    before do
      adds_contract_verification.add(:some_fake)
    end

    it "does not overwrite described_class in before" do
      syntax.run_before

      expect(syntax.described_class).to be_nil
    end

    it "does not change described_class in after" do
      syntax.run_before
      syntax.run_after

      expect(syntax.described_class).to be_nil
    end

    it_verifies_contract_after_suite

    it "adds recording to class based on fake name" do
      syntax.run_before

      expect(adds_recording).to have_received.add(:some_fake, ClassGuessedFromFakeName)
    end
  end
end
