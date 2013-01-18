require 'spec_helper'

module Bogus
  describe Double do
    shared_examples_for "double behavior" do
      it "tracks existence of test doubles" do
        mock(double_tracker).track(object)

        double.stub.foo("a", "b") { "the result" }
      end

      it "verifies stub definition" do
        mock(verifies_stub_definition).verify!(object, :foo, ["a", "b"])

        double.stub.foo("a", "b") { "the result" }
      end

      it "stubs shadow methods" do
        object.extend RecordInteractions
        mock(object.__shadow__).stubs(:foo, "a", "b")

        double.stub.foo("a", "b") { "the result" }
      end

      it "mocks shadow methods" do
        object.extend RecordInteractions
        mock(object.__shadow__).mocks(:foo, "a", "b")

        double.mock.foo("a", "b") { "the result" }
      end

      it "adds method overwriting" do
        double.stub.foo("a", "b") { "the result" }

        overwrites_methods.overwrites.should == [[object, :foo]]
      end

      it "records double interactions" do
        mock(records_double_interactions).record(object, :foo, ["a", "b"])

        double.stub.foo("a", "b") { "the result" }
      end
    end

    let(:double_tracker) { stub(track: nil) }
    let(:verifies_stub_definition) { stub(verify!: nil) }
    let(:records_double_interactions) { stub(record: nil) }
    let(:overwrites_methods) { FakeMethodOverwriter.new }
    let(:double) { isolate(Double) }

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
