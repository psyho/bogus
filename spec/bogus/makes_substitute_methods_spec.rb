require 'spec_helper'

module Bogus
  describe MakesSubstituteMethods do
    class SampleForCopyingMethods
      def self.foo(name, value = "hello", *rest, &block)
        "this is the method body"
      end
    end

    let(:method_stringifier) { isolate(MethodStringifier) }
    let(:makes_substitute_methods) { isolate(MakesSubstituteMethods) }

    it "makes a copy of the method with its params and adds recording" do
      copy = makes_substitute_methods.stringify(SampleForCopyingMethods.method(:foo))

      copy.should == <<-EOF
      def foo(name, value = {}, *rest, &block)
        __record__(:foo, name, value, *rest, &block)
      end
      EOF
    end
  end
end
