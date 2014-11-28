require 'spec_helper'

module Bogus
  describe CreatesFakesWithStubbedMethods do
    let(:creates_fakes) { FakeCreatorOfFakes.new }
    let(:fake_configuration) { double }
    let(:responds_to_everything) { double }
    let(:multi_stubber) { double }

    let(:creates_anonymous_stubs) { isolate(CreatesFakesWithStubbedMethods) }

    before do
      allow(fake_configuration).to receive(:include?) { false }
      allow(multi_stubber).to receive(:stub_all) { :stubbed_object }
    end

    context "given symbol as first parameter" do
      let(:fake) { [:foo, {as: :class}, "something"] }

      before do
        creates_anonymous_stubs.create(:foo, bar: 1, as: :class) { "something" }
      end

      it "creates fakes" do
        expect(creates_fakes).to have_created(:foo, {as: :class}, "something")
      end

      it "stubs all the given methods" do
        expect(multi_stubber).to have_received(:stub_all).with(fake, bar: 1)
      end
    end

    context "given hash as first parameter" do
      before do
        creates_anonymous_stubs.create(bar: 1)
      end

      it "does not create fakes" do
        expect(creates_fakes.fakes).to eq []
      end

      it "stubs all the given methods" do
        expect(multi_stubber).to have_received(:stub_all).with(responds_to_everything, bar: 1)
      end
    end

    context "given symbol as only parameter" do
      let(:fake) { [:foo, {}, "something"] }

      before do
        creates_anonymous_stubs.create(:foo) { "something" }
      end

      it "creates fakes" do
        expect(creates_fakes).to have_created(:foo, {}, "something")
      end

      it "stubs all the given methods" do
        expect(multi_stubber).to have_received(:stub_all).with(fake, {})
      end
    end

    context "with no parameters" do
      before do
        creates_anonymous_stubs.create
      end

      it "does not create fakes" do
        expect(creates_fakes.fakes).to eq []
      end

      it "stubs all the given methods" do
        expect(multi_stubber).to have_received(:stub_all).with(responds_to_everything, {})
      end
    end

    context "when the fake was globally configured" do
      let(:fake) { [:foo, {as: :class}, "SomeClass"] }

      before do
        allow(fake_configuration).to receive(:include?).with(:foo) { true }
        allow(fake_configuration).to receive(:get).with(:foo) { FakeDefinition.new(opts: {as: :class},
                                                                stubs: {xyz: "abc"},
                                                                class_block: proc{"SomeClass"}) }

        creates_anonymous_stubs.create(:foo)
      end

      it "uses the configuration to create fake" do
        expect(creates_fakes.fakes).to eq [fake]

        expect(fake_configuration).to have_received(:include?).with(:foo)
        expect(fake_configuration).to have_received(:get).with(:foo)
      end

      it "stubs the methods defined in configuration" do
        expect(multi_stubber).to have_received(:stub_all).with(fake, xyz: "abc")
      end
    end

    context "overriding the global configuration" do
      let(:fake) { [:foo, {as: :instance}, "SomeOtherClass"] }

      before do
        allow(fake_configuration).to receive(:include?).with(:foo) { true }
        allow(fake_configuration).to receive(:get).with(:foo) {
          FakeDefinition.new(opts: {as: :class},
                             stubs: {a: "b", b: "c"},
                             class_block: proc{"SomeClass"})
        }

        creates_anonymous_stubs.create(:foo, as: :instance, b: "d", c: "e") { "SomeOtherClass" }
      end

      it "overrides the class block and fake options" do
        expect(creates_fakes).to have_created(:foo, {as: :instance}, "SomeOtherClass")
      end

      it "overrides the stubbed methods" do
        expect(multi_stubber).to have_received(:stub_all).with(fake, a: "b", b: "d", c: "e")
      end
    end
  end
end
