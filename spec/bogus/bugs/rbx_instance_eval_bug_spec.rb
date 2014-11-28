require 'spec_helper'

describe Bogus do
  class SampleForRbxInstanceEval < BasicObject
    def x
      3
    end
  end

  it "doesn't break #instance_eval on RBX" do
    result = SampleForRbxInstanceEval.new.instance_eval{x}
    expect(result).to eq(3)
  end

  it "does not break === with the monkey patch" do
    expect(SampleForRbxInstanceEval === SampleForRbxInstanceEval.new).to be(true)
    expect(BasicObject === SampleForRbxInstanceEval.new).to be(true)
    expect(Bogus === SampleForRbxInstanceEval.new).to be(false)
  end
end
