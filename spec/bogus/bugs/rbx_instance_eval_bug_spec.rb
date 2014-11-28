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
end
