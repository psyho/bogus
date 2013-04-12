require 'spec_helper'

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

  let(:copies_classes) { Bogus.inject.copies_classes }
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

    it "should include class name in the output of fake's class #to_s" do
      fake.class.to_s.should include(klass.name)
    end

    it "should include class name in the output of fake's #to_s" do
      fake.to_s.should include(klass.name)
    end

    # TODO
    it "should override kind_of?/instance_of? for base classes of copied class"
    it "should override kind_of? for modules included into copied class"
  end

  shared_examples_for 'spying' do
    def should_record(method, *args)
      mock(subject).__record__(method, *args)

      subject.send(method, *args)
    end

    it "records method calls with no arguments" do
      should_record(:foo)
    end

    it "records method calls with explicit arguments" do
      should_record(:bar, 'hello')
    end

    it "records method calls with variable arguments" do
      should_record(:baz, 'hello', 'foo', 'bar', 'baz')
    end

    it "records method calls with default arguments" do
      should_record(:bam, hello: 'world')
    end
  end

  context "spying on an instance" do
    let(:klass) { FooWithInstanceMethods }
    subject{ fake }

    include_examples 'spying'
  end

  context "spying on copied class" do
    let(:klass) { ClassWithClassMethods }
    subject { fake_class }

    include_examples 'spying'
  end

  class SomeModel
    def save(*)
      # ignores arguments
    end
  end

  context "copying classes with methods with nameless parameters" do
    let(:klass) { SomeModel }

    it "copies those methods" do
      fake.should respond_to(:save)
    end
  end
end

