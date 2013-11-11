require 'spec_helper'

describe Bogus::OverwritesClasses do
  module SampleOuterModule
    module SampleModule
      class SampleClass
      end
    end
  end

  let(:new_class) { Class.new }
  let(:overwrites_classes) { Bogus::OverwritesClasses.new }

  it "overwrites nested classes" do
    overwrites_classes.overwrite('SampleOuterModule::SampleModule::SampleClass', new_class)

    expect(SampleOuterModule::SampleModule::SampleClass).to equal(new_class)
  end

  it "overwrites top level classes" do
    overwrites_classes.overwrite('SampleOuterModule', new_class)

    expect(SampleOuterModule).to equal(new_class)
  end
end

