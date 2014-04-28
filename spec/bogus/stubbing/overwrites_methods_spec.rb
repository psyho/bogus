require 'spec_helper'

module Bogus
  describe OverwritesMethods do
    let(:method_stringifier) { MethodStringifier.new }
    let(:makes_substitute_methods) { isolate(MakesSubstituteMethods) }
    let(:overwriter) { isolate(OverwritesMethods) }

    let(:object) { SampleOfOverwriting.new }

    context "with regular objects" do
      class SampleOfOverwriting
        def greet(name)
          "Hello #{name}"
        end

        def wave(part_of_body = "hand", speed = "slowly")
          "I'm waving my #{part_of_body} #{speed}"
        end
      end

      before do
        overwriter.overwrite(object, :greet)
      end

      it "does not change the method signature" do
        expect(object.method(:greet).arity).to eq(1)
      end

      it "does not change the method signature" do
        expect {
          object.greet("John", "Paul")
        }.to raise_error(ArgumentError)
      end

      it "adds interaction recording to the overwritten object" do
        object.greet("John")

        expect(object).to Bogus.have_received.greet("John")
        expect(object).not_to Bogus.have_received.greet("Paul")
      end

      it "can reset the overwritten methods" do
        overwriter.reset(object)

        expect(object.greet("John")).to eq("Hello John")
      end

      it "is imdepotent when overwriting" do
        overwriter.overwrite(object, :greet)
        overwriter.overwrite(object, :greet)
        overwriter.overwrite(object, :greet)

        overwriter.reset(object)

        expect(object.greet("John")).to eq("Hello John")
      end
    end

    context "with objects that use method missing" do
      class UsesMethodMissing
        def respond_to?(name)
          name == :greet
        end

        def method_missing(name, *args, &block)
          "the original return value"
        end
      end

      let(:object) { UsesMethodMissing.new }

      before do
        overwriter.overwrite(object, :greet)
      end

      it "can overwrite the non-existent methods" do
        expect(object.methods).to include(:greet)
      end

      it "can be reset back to the original state" do
        overwriter.overwrite(object, :greet)
        overwriter.overwrite(object, :greet)

        overwriter.reset(object)

        expect(object.greet).to eq("the original return value")
      end
    end

    context "with fakes" do
      let(:fake) { Samples::FooFake.new }

      it "does nothing because fakes methods already work as we need" do
        overwriter.overwrite(fake, :foo_bar)

        expect(fake).not_to respond_to(:foo_bar)
      end

      it "does not reset fakes, because there is nothing to reset" do
        expect {
          overwriter.reset(fake)
        }.not_to raise_error
      end
    end
  end
end
