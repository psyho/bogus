require 'spec_helper'

describe Bogus::CreatesFakes do
  let(:fake_class) { stub }
  let(:fake_instance) { stub }
  let(:converts_name_to_class) { stub }
  let(:copies_classes) { stub }
  let(:makes_ducks) { stub }
  let(:creates_fakes) { isolate(Bogus::CreatesFakes) }

  module Foo
  end

  module Bar
  end

  before { stub(fake_class).__create__{fake_instance} }

  context "without block" do
    before do
      mock(converts_name_to_class).convert(:foo) { Foo }
      mock(copies_classes).copy(Foo) { fake_class }
    end

    it "creates a new instance of copied class by default" do
      expect(creates_fakes.create(:foo)).to eq fake_instance
    end

    it "creates a new instance of copied class if called with as: :instance" do
      expect(creates_fakes.create(:foo, as: :instance)).to eq fake_instance
    end

    it "copies class but does not create an instance if called with as: :class" do
      expect(creates_fakes.create(:foo, as: :class)).to eq fake_class
    end

    it "raises an error if the as mode is not known" do
      expect do
        creates_fakes.create(:foo, as: :something)
      end.to raise_error(Bogus::CreatesFakes::UnknownMode)
    end
  end

  context "with block" do
    before do
      stub(converts_name_to_class).convert
      mock(copies_classes).copy(Bar) { fake_class }
    end

    it "uses the class provided" do
      expect(creates_fakes.create(:foo){Bar}).to eq fake_instance
    end

    it "does not convert the class name" do
      creates_fakes.create(:foo) { Bar}

      expect(copies_classes).to_not have_received.convert
    end
  end

  module FooBarDuck
  end

  context "with multiple classes" do
    it "creates a duck type out of those classes and fakes it" do
      stub(makes_ducks).make(Foo, Bar) { FooBarDuck }
      stub(copies_classes).copy(FooBarDuck) { :the_fake }

      fake = creates_fakes.create(:role, as: :class) { [Foo, Bar] }

      expect(fake).to eq :the_fake
    end
  end
end
