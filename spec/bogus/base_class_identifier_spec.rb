require 'spec_helper'

module SampleForBaseIdentifier
  describe Bogus::BaseClassIdentifier do
    module Foo
      def foo; end
    end

    module Bar
      include Foo
      def bar; end
    end

    module Baz
      def baz; end
    end

    module OtherModule
    end

    class SuperBase
    end

    class BaseClass < SuperBase
      include Bar
      def x; end
    end

    class SubClass < BaseClass
      include Baz
      def y; end
    end

    class OtherClass
    end

    class BarInstance
      include Bar
    end

    def self.it_returns_the_same_value_as_a_regular_instance
      klasses = [Foo, Bar, Baz, OtherModule,
        SuperBase, BaseClass, SubClass, OtherClass]
      klasses.each do |klass|
        it "returns the same for is_a?(#{klass})" do
          expected = instance.is_a?(klass)
          actual = Bogus::BaseClassIdentifier.base_class?(copied_class, klass)
          actual.should == expected
        end
      end
    end

    context "with copied module" do
      let(:copied_class) { Bar }
      let(:instance) { BarInstance.new }

      it_returns_the_same_value_as_a_regular_instance
    end

    context "with copied class" do
      let(:copied_class) { SubClass }
      let(:instance) { SubClass.new }

      it_returns_the_same_value_as_a_regular_instance
    end
  end
end
