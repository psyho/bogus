require 'spec_helper'

describe Bogus::GetsShadow do
  let(:rr_shadow) { lambda{ |o| {type: :rr, object: o} } }

  let(:gets_shadow) { isolate(Bogus::GetsShadow) }

  it "returns the fake's shadow for fakes" do
    fake = Samples::FooFake.new

    gets_shadow.for(fake).should == fake.__shadow__
  end

  it "returns a rr shadow for regular objects" do
    gets_shadow.for("foo").should == {type: :rr, object: "foo"}
  end
end
