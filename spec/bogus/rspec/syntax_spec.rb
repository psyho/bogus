require 'spec_helper'

describe Bogus::RSpecSyntax do
  context = self
  let(:syntax) { Bogus::RSpecSyntax.new(context) }

  it "gets the described class" do
    expect(syntax.described_class).to eq(Bogus::RSpecSyntax)
  end

  it "can set the described class" do
    syntax.described_class = Object

    expect(described_class).to eq(Object)
  end
end
