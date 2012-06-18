require_relative '../spec_helper'

describe Bogus::CreatesFakes do
  let(:fake_class) { stub() }
  let(:fake_instance) { stub() }
  let(:converts_name_to_class) { stub() }
  let(:copies_classes) { stub() }
  let(:creates_fakes) { Bogus::CreatesFakes.new(copies_classes, converts_name_to_class) }

  module Foo
  end

  module Bar
  end

  before { stub(fake_class).new{fake_instance} }

  context "without block" do
    before do
      mock(converts_name_to_class).convert(:foo) { Foo }
      mock(copies_classes).copy(Foo) { fake_class }
    end

    it "creates a new instance of copied class by default" do
      creates_fakes.create(:foo).should == fake_instance
    end

    it "creates a new instance of copied class if called with as: :instance" do
      creates_fakes.create(:foo, as: :instance).should == fake_instance
    end

    it "copies class but does not create an instance if called with as: :class" do
      creates_fakes.create(:foo, as: :class).should == fake_class
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
      creates_fakes.create(:foo){Bar}.should == fake_instance
    end

    it "does not convert the class name" do
      creates_fakes.create(:foo) { Bar}

      copies_classes.should_not have_received.convert
    end
  end
end
