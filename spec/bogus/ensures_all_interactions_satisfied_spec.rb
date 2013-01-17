require 'spec_helper'

describe Bogus::EnsuresAllInteractionsSatisfied do
  class FakeGetsShadow
    def for(object)
      object.__shadow__
    end
  end

  let(:gets_shadow) { FakeGetsShadow.new }
  let(:ensures_all_interactions_satisfied) { isolate(Bogus::EnsuresAllInteractionsSatisfied) }

  it "does nothing with all interactions satisfied" do
    objects = 3.times.map { |n| Samples::FooFake.new }

    expect {
      ensures_all_interactions_satisfied.ensure_satisfied!(objects)
    }.not_to raise_error
  end

  it "raises an error enumerating satisfied and unsatisfied interactions" do
    foo = Samples::FooFake.new
    foo.__shadow__.mock.foo("a", "b") { "result" }
    foo.__shadow__.mock.foo("a", "c") { "result 2" }
    foo.__shadow__.run(:foo, "a", "b")

    bar = Samples::FooFake.new
    bar.__shadow__.stub.foo("a", "b") { "result" }
    bar.__shadow__.stub.foo("a", "c") { "result 2" }
    bar.__shadow__.run(:foo, "a", "b")
    bar.__shadow__.run(:foo, "x", "y")

    msg = <<-EOF
    Some of the mocked interactions were not satisfied:

      - #{foo.inspect}.foo("a", "c")

    The following calls were recorded:

      - #{foo.inspect}.foo("a", "b")
      - #{bar.inspect}.foo("a", "b")
      - #{bar.inspect}.foo("x", "y")
    EOF

    expect {
      ensures_all_interactions_satisfied.ensure_satisfied!([foo, bar])
    }.to raise_error(Bogus::NotAllExpectationsSatisfied, msg.gsub(/ {4}/, ''))
  end

end
