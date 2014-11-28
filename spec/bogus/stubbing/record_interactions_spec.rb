require 'spec_helper'

describe Bogus::RecordInteractions do

  class SampleRecordsInteractions
    include Bogus::RecordInteractions
  end

  let(:sample) { SampleRecordsInteractions.new }

  it "allows verifying that interactions happened" do
    sample.__record__(:foo, 1, 2, 3)

    expect(sample.__shadow__.has_received(:foo, [1,2,3])).to be(true)
  end

  it "allows verifying that interactions didn't happen" do
    sample.__record__(:bar)

    expect(sample.__shadow__.has_received(:foo, [1,2,3])).to be(false)
  end

  it "returns self from record by default" do
    expect(sample.__record__(:foo)).to be_a_default_return_value
  end
end
