require 'spec_helper'

describe Bogus::HaveReceivedMatcher do
  let(:verifies_stub_definition) { double(:verifies_stub_definition, verify!: nil) }
  let(:records_double_interactions) { double(:records_double_interactions, record: nil) }
  let(:have_received_matcher) { isolate(Bogus::HaveReceivedMatcher) }
  let(:fake) { Samples::FooFake.new }

  before do
    fake.foo("a", "b")
  end

  shared_examples_for "have_received_matcher" do
    it "matches when the spy has received the message" do
      expect(fake).to bogus_have_received(:foo, "a", "b")
    end

    it "does not match if the spy hasn't received the message" do
      expect(fake).not_to bogus_have_received(:foo, "a", "c")
    end

    it "verifies that the method call has the right signature" do
      expect(verifies_stub_definition).to receive(:verify!).with(fake, :foo, ["a", "b"])

      bogus_have_received(:foo, "a", "b")

      have_received_matcher.matches?(fake)
    end

    it "records the interaction so that it can be checked by contract tests" do
      expect(records_double_interactions).to receive(:record).with(fake, :foo, ["a", "b"])

      bogus_have_received(:foo, "a", "b")

      have_received_matcher.matches?(fake)
    end

    it "returns a readable error message for object with no shadow" do
      bogus_have_received(:upcase)

      expect(have_received_matcher.matches?("foo")).to be_false
      expect(have_received_matcher.failure_message_for_should).to eq(Bogus::HaveReceivedMatcher::NO_SHADOW)
      expect(have_received_matcher.failure_message).to eq(Bogus::HaveReceivedMatcher::NO_SHADOW)
      expect(have_received_matcher.failure_message_for_should_not).to eq(Bogus::HaveReceivedMatcher::NO_SHADOW)
      expect(have_received_matcher.failure_message_when_negated).to eq(Bogus::HaveReceivedMatcher::NO_SHADOW)
    end

    it "returns a readable error message for fakes" do
      bogus_have_received(:foo, "a", "c")

      have_received_matcher.matches?(fake)

      message =
        %Q{Expected #{fake.inspect} to have received foo("a", "c"), but it didn't.\n\n}+
        %Q{The recorded interactions were:\n} +
        %Q{  - foo("a", "b")\n}

      expect(have_received_matcher.failure_message_for_should).to eq(message)
      expect(have_received_matcher.failure_message).to eq(message)
    end
  end

  context "with method_missing builder" do
    def bogus_have_received(method, *args)
      have_received_matcher.build.__send__(method, *args)
    end

    include_examples "have_received_matcher"
  end

  context "with method call builder" do
    def bogus_have_received(*args)
      have_received_matcher.build(*args)
    end

    include_examples "have_received_matcher"
  end
end
