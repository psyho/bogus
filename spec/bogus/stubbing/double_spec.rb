require 'spec_helper'

module Bogus
  describe Double do
    shared_examples_for "double behavior" do
      it "tracks existence of test doubles" do
        expect(double_tracker).to receive(:track).with(object)

        double_instance.stub.foo("a", "b") { "the result" }
      end

      it "does not track existence of the double if verify fails" do
        allow(verifies_stub_definition).to receive(:verify!).with(object, :foo, ["a", "b"]) { raise NameError }

        expect {
          double_instance.stub.foo("a", "b") { "the result" }
        }.to raise_error

        expect(double_tracker).not_to have_received(:track).with(object)
      end

      it "verifies stub definition" do
        expect(verifies_stub_definition).to receive(:verify!).with(object, :foo, ["a", "b"])

        double_instance.stub.foo("a", "b") { "the result" }
      end

      it "stubs shadow methods" do
        object.extend RecordInteractions
        expect(object.__shadow__).to receive(:stubs).with(:foo, "a", "b")

        double_instance.stub.foo("a", "b") { "the result" }
      end

      it "mocks shadow methods" do
        object.extend RecordInteractions
        expect(object.__shadow__).to receive(:mocks).with(:foo, "a", "b")

        double_instance.mock.foo("a", "b") { "the result" }
      end

      it "adds method overwriting" do
        double_instance.stub.foo("a", "b") { "the result" }

        expect(overwrites_methods.overwrites).to eq([[object, :foo]])
      end

      it "records double interactions" do
        expect(records_double_interactions).to receive(:record).with(object, :foo, ["a", "b"])

        double_instance.stub.foo("a", "b") { "the result" }
      end
    end

    let(:double_tracker) { double(:double_tracker, track: nil) }
    let(:verifies_stub_definition) { double(:verifies_stub_definition, verify!: nil) }
    let(:records_double_interactions) { double(:records_double_interactions, record: nil) }
    let(:overwrites_methods) { FakeMethodOverwriter.new }
    let(:double_instance) { isolate(Double) }

    context "with regular objects" do
      let(:object) { Samples::Foo.new }

      include_examples "double behavior"
    end

    context "with fakes" do
      let(:object) { Samples::FooFake.new }

      include_examples "double behavior"
    end

    class FakeMethodOverwriter
      def overwrite(object, method)
        overwrites << [object, method]
        object.extend RecordInteractions
      end

      def overwrites
        @overwrites ||= []
      end
    end
  end
end
