Feature: Configuration Options

  Bogus can be configured, similarly to many other frameworks with a configure block.  This feature describes the configuration options available.

  Scenario: search_modules
    Given a file named "foo.rb" with:
    """ruby
    class Foo
      def foo
      end
    end

    module Bar
      class Baz
        def baz
        end
      end
    end
    """

    Then spec file with following content should pass:
    """ruby

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


