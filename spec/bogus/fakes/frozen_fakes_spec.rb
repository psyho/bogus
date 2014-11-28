require "spec_helper"

describe "Frozen Fakes" do
  before do
    extend Bogus::MockingDSL
  end

  class ExampleForFreezing
    def foo(x)
    end
  end

  shared_examples_for "frozen fakes" do
    before { object.freeze }

    describe "stubbing" do
      it "allows stubbing" do
        stub(object).foo(1) { 123 }

        expect(object.foo(1)).to eq 123
      end
    end

    describe "mocking" do
      it "allows mocking" do
        mock(object).foo(1) { 123 }

        expect(object.foo(1)).to eq 123
      end

      it "allows verifying expectations" do
        mock(object).foo(1) { 123 }

        expect {
          Bogus.after_each_test
        }.to raise_error(Bogus::NotAllExpectationsSatisfied)
      end
    end

    describe "spying" do
      it "allows spying" do
        object.foo(1)

        expect(object).to have_received.foo(1)
        expect(object).to_not have_received.foo(2)
      end
    end
  end

  context "anonymous fakes" do
    let(:object) { fake }

    include_examples "frozen fakes"
  end

  context "named fakes" do
    let(:object) { fake(:example_for_freezing) }

    include_examples "frozen fakes"
  end
end
