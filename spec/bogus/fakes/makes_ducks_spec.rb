require 'spec_helper'

module Bogus
  describe MakesDucks do
    class DatabaseLogger
      def debug(message); end
      def warn(*args); end
      def error(message, another_arg); end
      def log(opts = {}); end

      def self.foo(x, y, z = 1); end
      def self.bar(x, y); end
    end

    class NetworkLogger
      def debug(message); end
      def warn(*args); end
      def error(message); end
      def socket; end

      def self.foo(x, y, z = 1); end
      def self.bar(x, y, z); end
      def self.baz; end
    end

    let(:class_methods) do
      lambda{ |klass| ClassMethods.new(klass) }
    end

    let(:instance_methods) do
      lambda{ |klass| InstanceMethods.new(klass) }
    end

    let(:makes_ducks) { Bogus.inject.makes_ducks }
    let(:duck) { makes_ducks.make(DatabaseLogger, NetworkLogger) }

    describe "the returned class" do
      subject { duck }

      it { should respond_to(:foo) }

      it "should have arity -3 for foo" do
        expect(duck.method(:foo).arity).to eq -3
      end

      it { should_not respond_to(:bar) }
      it { should_not respond_to(:baz) }
    end

    describe "instances of the returned class" do
      subject { duck.new }

      it { should respond_to(:debug) }
      it { should respond_to(:warn) }
      it { should_not respond_to(:error) }
      it { should_not respond_to(:socket) }
    end

    module AlwaysEnabled
      def enabled?; true; end
      extend self
    end

    module AlwaysDisabled
      def enabled?; false; end
      extend self
    end

    context "with modules" do
      let(:duck) { makes_ducks.make(AlwaysDisabled, AlwaysEnabled)}

      let(:duck_instance) do
        object = Object.new
        object.extend duck
        object
      end

      it "copies class methods" do
        expect(duck).to respond_to(:enabled?)
      end

      it "copies instance methods" do
        expect(duck_instance).to respond_to(:enabled?)
      end
    end
  end
end
