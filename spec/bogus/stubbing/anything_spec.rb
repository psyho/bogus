require 'spec_helper'

describe Bogus::Anything do
  it "is equal to everything" do
    anything = Bogus::Anything

    expect(anything).to eq("foo")
    expect(anything).to eq("bar")
    expect(anything).to eq(1)
    expect(anything).to eq(Object.new)
    expect(anything).to eq(anything)
  end
end
