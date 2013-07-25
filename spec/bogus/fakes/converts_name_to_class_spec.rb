require 'spec_helper'

describe Bogus::ConvertsNameToClass do
  FooBarBaz = Class.new

  module Foo
    FooBarBaz = Class.new
  end

  module Bar
    FooBarBaz = Class.new
    Bam = Class.new
  end

  it "finds classes in golbal namespace by default" do
    converts_name_to_class = Bogus::ConvertsNameToClass.new(Bogus.config.search_modules)

    converts_name_to_class.convert(:foo_bar_baz).should == FooBarBaz
  end

  it "looks in the modules in the specified order" do
    converts_name_to_class = Bogus::ConvertsNameToClass.new([Foo, Bar])

    converts_name_to_class.convert(:foo_bar_baz).should == Foo::FooBarBaz
  end

  it "looks in the next module on the list if the first does not contain the class" do
    converts_name_to_class = Bogus::ConvertsNameToClass.new([Foo, Bar])

    converts_name_to_class.convert(:bam).should == Bar::Bam
  end

  it "raises an error if it can't find the class" do
    converts_name_to_class = Bogus::ConvertsNameToClass.new([Foo])

    expect do
      converts_name_to_class.convert(:bam)
    end.to raise_error(Bogus::ConvertsNameToClass::CanNotFindClass)
  end
end
