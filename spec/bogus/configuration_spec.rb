require_relative '../spec_helper'

describe Bogus::Configuration do
  before { Bogus.reset! }

  it "stores the modules to be searched" do
    Bogus.configure do |c|
      c.search_modules << String
    end

    expect(Bogus.config.search_modules).to eq [Object, String]
  end

  it "defaults search_modules to [Object]" do
    expect(Bogus.config.search_modules).to eq [Object]
  end
end
