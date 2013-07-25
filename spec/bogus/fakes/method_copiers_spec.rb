require 'spec_helper'

describe "Method Copiers" do
  shared_examples_for "method copier" do
    let(:klass) { Class.new }
    subject { isolate(described_class) }

    it { should respond_to(:all) }
    it { should respond_to(:get) }
    it { should respond_to(:remove) }
    it { should respond_to(:define) }
  end

  describe Bogus::InstanceMethods do
    it_behaves_like "method copier"
  end

  describe Bogus::ClassMethods do
    it_behaves_like "method copier"
  end

  describe Bogus::ActiveRecordAccessors do
    let(:instance_methods) { nil }
    it_behaves_like "method copier"
  end
end
