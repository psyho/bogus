require 'spec_helper'

module Bogus
  describe ClassMethods do
    class SampleClass
      def foo(bar)
      end

      def self.bar(bam)
      end

      def self.hello
      end

      def self.__shadow__; end
      def self.__reset__; end
      def self.__overwrite__; end
      def self.__overwritten_methods__; end
      def self.__record__; end
    end

    let(:class_methods) { ClassMethods.new(SampleClass) }

    it "lists the class methods excluding the ones added by Bogus" do
      class_methods.all.should =~ [:bar, :hello]
    end

    it "returns the instance methods by name" do
      class_methods.get(:bar).should ==
        SampleClass.method(:bar)
    end

    it "removes methods by name" do
      class_methods.remove(:hello)

      SampleClass.should_not respond_to(:hello)
    end

    it "defines instance methods" do
      class_methods.define <<-EOF
      def greet(name)
        return "Hello, " + name + "!"
      end
      EOF

      SampleClass.greet("Joe").should == "Hello, Joe!"
    end
  end
end

