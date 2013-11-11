require 'spec_helper'

describe "Ruby syntax" do
  it "is clean" do
    expect(bogus_warnings).to eq []
  end

  def bogus_warnings
    warnings.select { |w| w match(%r{lib/bogus}) }
  end

  def warnings
    `ruby -w lib/bogus.rb 2>&1`.split("\n")
  end
end
