require 'spec_helper'

describe "Ruby syntax" do
  it "is clean" do
    `ruby -w lib/bogus.rb 2>&1`.should == ''
  end
end
