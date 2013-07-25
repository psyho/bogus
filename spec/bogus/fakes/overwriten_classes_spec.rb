require 'spec_helper'

describe Bogus::OverwrittenClasses do
  let(:overwritten_classes) { Bogus::OverwrittenClasses.new }

  let(:klass) { Class.new }

  it "adds classes" do
    overwritten_classes.add("Foo::Bar", klass)
    overwritten_classes.add("Baz::Bam", klass)

    overwritten_classes.classes.should == [["Foo::Bar", klass],
                                           ["Baz::Bam", klass]]
  end

  it "clears overwritten classes" do
    overwritten_classes.add("Foo::Bar", klass)
    overwritten_classes.add("Baz::Bam", klass)
    overwritten_classes.clear

    overwritten_classes.classes.should == []
  end

  it "returns an empty array with no classes" do
    overwritten_classes.classes.should == []
  end
end
