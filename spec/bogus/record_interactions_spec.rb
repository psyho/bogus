require 'spec_helper'

describe Bogus::RecordInteractions,
  pending: 'requires rewriting specs to use rr' do

  class SampleRecordsInteractions
    include Bogus::RecordInteractions
  end

  let(:sample) { SampleRecordsInteractions.new }
  let!(:rr) { Bogus::RRProxy }

  it "allows verifying that interactions happened" do
  end

  it "allows verifying that interactions didn't happen" do
  end
end
