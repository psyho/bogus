require 'spec_helper'

describe Bogus::TracksExistenceOfTestDoubles do
  let(:tracker) { Bogus::TracksExistenceOfTestDoubles.new }

  it "returns an empty double list with nothing tracked" do
    tracker.doubles.should == []
  end

  it "lists the added test doubles in order without duplicates" do
    foo = "foo"
    bar = 1
    baz = Object.new

    tracker.track foo
    tracker.track bar
    tracker.track foo
    tracker.track baz
    tracker.track baz
    tracker.track bar
    tracker.track foo


    tracker.doubles.should == [foo, bar, baz]
  end
end
