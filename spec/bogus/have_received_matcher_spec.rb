require 'spec_helper'

describe Bogus::HaveReceivedMatcher do
  let(:verifies_stub_definition) { stub(verify!: nil) }
  let(:records_double_interactions) { stub(record: nil) }
  let(:have_received_matcher) { isolate(Bogus::HaveReceivedMatcher) }
  let(:have_received) { have_received_matcher.method_call }
  let(:fake) { Samples::FooFake.new }

  before do
    fake.foo("a", "b")
  end

  it "matches when the spy has received the message" do
    fake.should have_received.foo("a", "b")
  end

  it "does not match if the spy hasn't received the message" do
    fake.should_not have_received.foo("a", "c")
  end

  it "verifies that the method call has the right signature" do
    mock(verifies_stub_definition).verify!(fake, :foo, ["a", "b"])

    have_received.foo("a", "b")

    have_received_matcher.matches?(fake)
  end

  it "records the interaction so that it can be checked by contract tests" do
    mock(records_double_interactions).record(fake, :foo, ["a", "b"])

    have_received.foo("a", "b")

    have_received_matcher.matches?(fake)
  end

  it "returns a readable error message for object with no shadow" do
    have_received.upcase

    have_received_matcher.matches?("foo").should be_false
    have_received_matcher.failure_message_for_should.should == Bogus::HaveReceivedMatcher::NO_SHADOW
    have_received_matcher.failure_message_for_should_not.should == Bogus::HaveReceivedMatcher::NO_SHADOW
  end

  it "returns a readable error message for fakes" do
    have_received.foo("a", "c")

    have_received_matcher.matches?(fake)

    have_received_matcher.failure_message_for_should.should ==
      %Q{Expected #{fake.inspect} to have received foo("a", "c"), but it didn't.\n\n}+
        %Q{The recorded interactions were:\n} +
        %Q{  - foo("a", "b")\n}
  end
end
