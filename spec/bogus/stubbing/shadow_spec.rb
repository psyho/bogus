require 'spec_helper'

describe Bogus::Shadow do
  let(:object) { Samples::FooFake.new }
  let(:shadow) { Bogus::Shadow.new }

  shared_examples_for "spying on shadows" do
    context "spying" do
      before do
        shadow.run(:foo, "a", "b") rescue nil # for when the method raises an error
      end

      it "returns the called methods" do
        expect(shadow.has_received(:foo, ["a", "b"])).to be_true
      end

      it "does not return true for interactions that did not happen" do
        expect(shadow.has_received(:foo, ["a", "c"])).to be_false
        expect(shadow.has_received(:bar, ["a", "c"])).to be_false
      end
    end
  end

  context "unrecorded interactions" do
    it "returns an unstubbed value" do
      return_value = shadow.run(:foo, "a", "b")

      expect(return_value).to be_a_default_return_value
    end

    include_examples "spying on shadows"
  end

  context "interactions that raise exceptions" do
    class SomeWeirdException < StandardError; end

    before do
      shadow.stubs(:foo, "a", "b") { raise SomeWeirdException, "failed!" }
    end

    it "raises the error when called" do
      expect {
        shadow.run(:foo, "a", "b")
      }.to raise_error(SomeWeirdException, "failed!")
    end

    include_examples "spying on shadows"
  end

  context "interactions with no return value" do
    before do
      shadow.stubs(:foo, ["a", "b"])
    end

    it "returns the default value" do
      expect(shadow.run(:foo, ["a", "b"])).to be_a_default_return_value
    end

    include_examples "spying on shadows"
  end

  context "interactions with AnyArgs" do
    before do
      shadow.stubs(:foo, "a", "b") { "old specific value" }
      shadow.stubs(:foo, Bogus::AnyArgs) { "default value" }
      shadow.stubs(:foo, "a", "d") { "new specific value" }
    end

    it "changes the default value returned from method" do
      expect(shadow.run(:foo, "b", "c")).to eq("default value")
    end

    it "overwrites the old specific stubbed values" do
      expect(shadow.run(:foo, "a", "b")).to eq("default value")
    end

    it "does not affect the new specific stubbed values" do
      expect(shadow.run(:foo, "a", "d")).to eq("new specific value")
    end

    it "allows spying on calls using any args" do
      shadow.run(:foo, "a", "c")

      expect(shadow.has_received(:foo, [Bogus::AnyArgs])).to be_true
    end
  end

  context "interactions that take anything" do
    before do
      shadow.stubs(:foo, "a", Bogus::Anything) { "return value" }
    end

    it "changes the return value for calls that match" do
      expect(shadow.run(:foo, "a", "c")).to eq("return value")
    end

    it "does not affect the return value for other calls" do
      shadow.stubs(:foo, "a", "b") { "specific value" }

      expect(shadow.run(:foo, "a", "b")).to eq("specific value")
    end

    it "allows spying on calls using anything in args" do
      shadow.run(:foo, "a", "b")

      expect(shadow.has_received(:foo, [Bogus::Anything, "b"])).to be_true
    end
  end

  context "stubbed interactions" do
    before do
      shadow.stubs(:foo, "a", "b") { "stubbed value" }
    end

    it "returns the stubbed value" do
      expect(shadow.run(:foo, "a", "b")).to eq("stubbed value")
    end

    it "returns the latest stubbed value" do
      shadow.stubs(:foo, "a", "b") { "stubbed twice" }
      shadow.stubs(:foo, "b", "c") { "different params" }

      expect(shadow.run(:foo, "a", "b")).to eq("stubbed twice")
      expect(shadow.run(:foo, "b", "c")).to eq("different params")
    end

    it "returns the default value for non-stubbed calls" do
      expect(shadow.run(:foo, "c", "d")).to be_a_default_return_value
      expect(shadow.run(:bar)).to be_a_default_return_value
    end

    it "does not contribute towards unsatisfied interactions" do
      expect(shadow.unsatisfied_interactions).to be_empty
    end

    it "adds required interaction when mocking over stubbing" do
      shadow.mocks(:foo, "a", "b") { "stubbed value" }

      expect(shadow.unsatisfied_interactions).not_to be_empty
    end

    include_examples "spying on shadows"
  end

  context "mocked interactions" do
    before do
      shadow.mocks(:foo, "a", "b") { "mocked value" }
    end

    it "returns the mocked value" do
      expect(shadow.run(:foo, "a", "b")).to eq("mocked value")
    end

    it "overwrites the stubbed value" do
      shadow.stubs(:foo, "a", "c") { "stubbed value" }
      shadow.mocks(:foo, "a", "c") { "mocked value" }

      expect(shadow.run(:foo, "a", "c")).to eq("mocked value")
    end

    it "is overwritten by stubbing" do
      shadow.mocks(:foo, "a", "c") { "mocked value" }
      shadow.stubs(:foo, "a", "c") { "stubbed value" }

      expect(shadow.run(:foo, "a", "c")).to eq("stubbed value")
    end

    it "removes the required interaction when stubbing over mocking" do
      shadow.stubs(:foo, "a", "b") { "stubbed value" }

      expect(shadow.unsatisfied_interactions).to be_empty
    end

    it "returns the default value for non-stubbed calls" do
      expect(shadow.run(:foo, "a", "c")).to be_a_default_return_value
    end

    it "contributes towards unsatisfied interactions" do
      interactions = shadow.unsatisfied_interactions
      expect(interactions).to have(1).item
      expect(interactions.first.method).to eq(:foo)
      expect(interactions.first.args).to eq(["a", "b"])
    end

    it "removes the staisfied expectations from unsatisfied interactions" do
      shadow.mocks(:with_optional_args, 'a')
      shadow.run(:with_optional_args, 'a', Bogus::DefaultValue)
      shadow.run(:foo, "a", "b")

      expect(shadow.unsatisfied_interactions).to be_empty
    end

    include_examples "spying on shadows"
  end
end
