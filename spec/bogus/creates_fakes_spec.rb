require_relative '../spec_helper'

describe Bogus::CreatesFakes do
  let(:fake_class) { stub(:fake_class, :new => fake_instance) }
  let(:fake_instance) { stub(:fake_instance) }
  let(:converts_name_to_class) { stub(:converts_name_to_class) }
  let(:copies_classes) { stub(:copies_classes) }
  let(:creates_fakes) { Bogus::CreatesFakes.new(copies_classes, converts_name_to_class) }

  module Foo
  end

  before do
    converts_name_to_class.should_receive(:convert).with(:foo).and_return(Foo)
    copies_classes.should_receive(:copy).with(Foo).and_return(fake_class)
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
