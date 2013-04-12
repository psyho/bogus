require 'spec_helper'

module Bogus
  describe InstanceMethods do
    class SampleClass
      def foo(bar)
      end

      def hello
      end

      def self.bar(bam)
      end
    end

    let(:instance_methods) { InstanceMethods.new(SampleClass) }

    it "lists the instance methods" do
      instance_methods.all.should == [:foo, :hello]
    end

    it "returns the instance methods by name" do
      instance_methods.get(:foo).should ==
        SampleClass.instance_method(:foo)
    end

    it "removes methods by name" do
      instance_methods.remove(:hello)

      SampleClass.new.should_not respond_to(:hello)
    end

    it "defines instance methods" do
      instance_methods.define <<-EOF
      def greet(name)
        return "Hello, " + name + "!"
      end
      EOF

      instance = SampleClass.new

      instance.greet("Joe").should == "Hello, Joe!"
    end
  end
end
