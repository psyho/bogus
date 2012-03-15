Feature: Faking existing classes

  Bogus makes it easy to create fakes, which behave like a nil-object and
  have the same interface as the object being faked.

  Scenario: Calling methods that exist on real object
    Given a file named "logger.rb" with:
    """ruby
    class Logger
      def info(message)
      end
    end
    """

    And a file named "foo.rb" with:
    """ruby
    class Foo
      def self.do_something(logger = Logger.new)
        logger.info("hello world")
        true
      end
    end
    """

    And a file named "spec_helper.rb" with:
    """ruby
    require 'bogus'
    require 'bogus/rspec'
    """

    And a file named "foo_spec.rb" with:
    """ruby
    require_relative 'spec_helper'

    require_relative 'logger'
    require_relative 'foo'

    describe Foo do
      fake(:logger)

      it "does something" do
        Foo.do_something(logger).should be_true
      end
    end
    """

    When I run `rspec foo_spec.rb`
    Then all the specs should pass
