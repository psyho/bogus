require 'spec_helper'

describe Bogus::RecordInteractions do

  class SampleRecordsInteractions
    include Bogus::RecordInteractions
  end

  let(:sample) { SampleRecordsInteractions.new }

  it "allows verifying that interactions happened" do
    sample.__record__(:foo, 1, 2, 3)

    sample.__shadow__.has_received(:foo, [1,2,3]).should be_true
  end

  it "allows verifying that interactions didn't happen" do
    sample.__record__(:bar)

    sample.__shadow__.has_received(:foo, [1,2,3]).should be_false
  end

  it "returns self from record by default" do
    sample.__record__(:foo).should == sample
  end
end
