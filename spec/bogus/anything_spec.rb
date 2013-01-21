require 'spec_helper'

describe Bogus::Anything do
  it "is equal to everything" do
    anything = Bogus::Anything

    anything.should == "foo"
    anything.should == "bar"
    anything.should == 1
    anything.should == Object.new
    anything.should == anything
  end
end
