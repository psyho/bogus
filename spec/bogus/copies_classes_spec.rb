require_relative '../spec_helper'

describe Bogus::CopiesClasses do
  module SampleMethods
    def foo
    end

    def bar(x)
    end

    def baz(x, *y)
    end

    def bam(opts = {})
    end

    def baa(x, &block)
    end
  end

  shared_examples_for 'the copied class' do
    it "copies methods with no arguments" do
      subject.should respond_to(:foo)
      subject.foo
    end

    it "copies methods with explicit arguments" do
      subject.should respond_to(:bar)

      subject.method(:bar).arity.should == 1

      subject.bar('hello')
    end

    it "copies methods with variable arguments" do
      subject.should respond_to(:baz)

      subject.baz('hello', 'foo', 'bar', 'baz')
    end

    it "copies methods with default arguments" do
      subject.should respond_to(:bam)

      subject.bam
      subject.bam(hello: 'world')
    end

    it "copies methods with block arguments" do
      subject.should respond_to(:baa)

      subject.baa('hello')
      subject.baa('hello') {}
    end

    it "makes the methods chainable" do
      subject.foo.bar('hello').baz('hello', 'world', 'foo').bam.baa('foo')
    end
  end

  let(:method_stringifier) { Bogus::MethodStringifier.new }
  let(:copies_classes) { Bogus::CopiesClasses.new(method_stringifier) }
  let(:fake_class) { copies_classes.copy(klass) }
  let(:fake) { fake_class.new }

  class FooWithInstanceMethods
    include SampleMethods
  end

  context "instance methods" do
    let(:klass) { FooWithInstanceMethods }
    subject{ fake }

    it_behaves_like 'the copied class'
  end

  context "constructors" do
    let(:klass) {
      Class.new do
        def initialize(hello)
        end
      end
    }

    it "adds a constructor that allows passing any number of arguments" do
      fake_class.new('hello', 'w', 'o', 'r', 'l', 'd') { test }
    end
  end

  class ClassWithClassMethods
    extend SampleMethods
  end

  context "class methods" do
    let(:klass) { ClassWithClassMethods }
    subject{ fake_class }

    it_behaves_like 'the copied class'
  end

  context "identification" do
    module SomeModule
      class SomeClass
      end
    end

    let(:klass) { SomeModule::SomeClass }

    it "should copy the class name" do
      fake.class.name.should == 'SomeModule::SomeClass'
    end

    it "should override kind_of?" do
      fake.should be_kind_of(SomeModule::SomeClass)
    end

    it "should override instance_of?" do
      fake.should be_instance_of(SomeModule::SomeClass)
    end

    it "should override is_a?" do
      fake.should be_a(SomeModule::SomeClass)
    end

    # TODO
    it "should override kind_of?/instance_of? for base classes of copied class"
    it "should override kind_of? for modules included into copied class"
  end
end

