require 'spec_helper'

describe Bogus::RecordInteractions do

  class SampleRecordsInteractions
    include Bogus::RecordInteractions
  end

  let(:sample) { SampleRecordsInteractions.new }
  let!(:rr) { Bogus::RRProxy }

  it "allows verifying that interactions happened" do
    sample.__record__(:foo, 1, 2, 3)

    sample.__inner_object__.should have_received.foo(1, 2, 3)
  end

  it "allows verifying that interactions didn't happen" do
    sample.__record__(:bar)

    sample.__inner_object__.should_not have_received.foo
  end

  it "returns self from record" do
    sample.__record__(:foo).should == sample
  end
end
