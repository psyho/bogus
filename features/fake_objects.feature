Feature: Faking existing classes

  Bogus makes it easy to create fakes, which behave like a null-object and
  have the same interface as the object being faked.

  Background:
    Given a file named "foo.rb" with:
    """ruby
    class Logger
      def info(message)
      end

      def warn(message)
      end

      def self.foo(bar)
      end
    end

    class Foo
      def self.do_something(logger = Logger.new)
        logger.info("hello world")
        true
      end
    end
    """

  Scenario: Calling methods that exist on real object
    Then spec file with following content should pass:
    """ruby
    describe Foo do
      fake(:logger)

      it "does something" do
        Foo.do_something(logger).should be_true
      end
    end
    """

  Scenario: Fakes have null-object semantics
    Then spec file with following content should pass:
    """ruby
    describe "logger fake" do
      fake(:logger)

      it "returns self from all methods" do
        logger.info("hello").should == logger
      end

      it "makes method chaining possible" do
        logger.info("hello").warn("world").should == logger
      end
    end
    """

  Scenario: Taking the guesswork out of finding a class to copy
    Then spec file with following content should pass:
    """ruby
    class OtherLogger
      def info(msg)
      end
    end

    describe "logger fake" do
      fake(:logger) { OtherLogger }

      it "uses the class provided in block instead of the guessed one" do
        logger.class.name.should == "OtherLogger"
      end
    end
    """

  Scenario: Fakes which are classes
    Then spec file with following content should pass:
    """ruby
    describe "logger class fake" do
      fake(:logger, as: :class)

      it "is a class" do
        logger.should be_a(Class)
      end

      it "has the same name as original class" do
        logger.name.should == Logger.name
      end

      it "has same methods as original class" do
        logger.foo('something')
      end
    end
    """

  Scenario: Fakes which are objects
    Given pending
