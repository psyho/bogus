require 'spec_helper'

describe Bogus::Fake do
  it 'has a class name' do
    Bogus::Fake.name.should == "Bogus::Fake"
  end
end

