Bogus let's you stub methods on any object, not just fakes, which makes this feature usable even in scenarios when you don't follow the Inversion of Control Principle.

When you stub/mock a method in Bogus, it will automatically ensure that:

1. The method actually exists
2. It can take the number of arguments you passed

Those of you familiar with RR stubbing syntax, will feel right at home with Bogus:

    stub(object).method_name(*arguments) { return_value }

One key difference is for when you want to stub a method for any arguments:

    # RR syntax
    stub(object).method_name { return_value }

    # Bogus syntax
    stub(object).method_name(any_args) { return_value }

One other, quite important thing, is that Bogus does not erase the method signature when stubbing:

    class Library
      def self.checkout(book)
      end
    end

The following would be OK in RR:

    stub(Library).checkout { "foo" }
    Library.checkout("a", "b") # returns "foo"

But not in Bogus:

    stub(Library).checkout(any_args) { "foo" }
    Library.checkout("a", "b") # raises an error
