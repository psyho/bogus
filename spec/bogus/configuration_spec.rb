require_relative '../spec_helper'

describe Bogus::Configuration do
  after { Bogus.reset! }

  it "stores the modules to be searched" do
    Bogus.configure do |c|
      c.search_modules << String
    end

    Bogus.config.search_modules.should == [Object, String]
  end

  it "defaults search_modules to [Object]" do
    Bogus.config.search_modules.should == [Object]
  end
end
