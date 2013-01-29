Feature: Argument matchers

  Bogus supports some argument matchers for use, when you don't really
  care about exact equality of arguments passed in or spied on.

  Background:
    Given a file named "foo.rb" with:
    """ruby
    class Catalog
      def self.books_by_author_and_title(author, title)
      end
    end
    """

  Scenario: Stubbing methods with any arguments
    Then the following test should pass:
    """ruby
    stub(Catalog).books_by_author_and_title(any_args) { :some_book }

    Catalog.books_by_author_and_title("Mark Twain", "Tom Sawyer").should == :some_book
    """

  Scenario: Stubbing methods with some wildcard arguments
    Then the following test should pass:
    """ruby
    stub(Catalog).books_by_author_and_title("Mark Twain", anything) { :twains_book }

    Catalog.books_by_author_and_title("Mark Twain", "Tom Sawyer").should == :twains_book
    Catalog.books_by_author_and_title("Mark Twain", "Huckleberry Finn").should == :twains_book
    """

