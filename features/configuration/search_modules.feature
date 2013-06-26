Feature: search_modules

  Most projects do not have a separate namespace for their classes, which the default that Bogus assumes. However, if all (or some) of your classes exist within some module you can add it to the list of modules that Bogus will look in when trying to resolve class names.

  Scenario: search_modules
    Given a file named "foo.rb" with:
    """ruby
    class Foo
      def foo
      end
    end
    """

    Given a file named "baz.rb" with:
    """ruby
    module Bar
      class Baz
        def baz
        end
      end
    end
    """

    Then spec file with following content should pass:
    """ruby
    require_relative 'foo'
    require_relative 'baz'

    Bogus.configure do |c|
      c.search_modules << Bar
    end

    describe "logger class fake" do
      fake(:foo)
      fake(:baz)

      it "finds classes in global namespace" do
        foo.foo
      end

      it "finds classes in specified modules" do
        baz.baz
      end
    end
    """


