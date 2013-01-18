Feature: Safe stubbing

  Most Ruby test double libraries let you stub methods that don't exist.
  Bogus is different in this respect: not only does it not allow stubbing 
  methods that don't exist, it also ensures that the number of arguments
  you pass to those methods matches the method definition.

  Background:
    Given a file named "foo.rb" with:
    """ruby
    class Library
      def checkout(book)
      end
    end
    """

  Scenario: Stubbing methods that exist on real object
    Then spec file with following content should pass:
    """ruby
    describe Library do

      it "does something" do
        library = Library.new
        stub(library).checkout("some book") { :checked_out }

        library.checkout("some book").should == :checked_out
      end
    end
    """

  Scenario: Stubbing methods that do not exist on real object
    Then spec file with following content should fail:
    """ruby
    describe Library do
      it "does something" do
        library = Library.new
        stub(library).buy("some book") { :bought }
      end
    end
    """

  Scenario: Stubbing methods with wrong number of arguments
    Then spec file with following content should fail:
    """ruby
    describe Library do
      it "does something" do
        library = Library.new
        stub(library).checkout("some book", "another book") { :bought }
      end
    end
    """

  Scenario: Stubs allow the methods to be called
    Then spec file with following content should pass:
    """ruby
    describe Library do
      it "does something" do
        library = Library.new
        stub(library).checkout("some book") { :bought }
      end
    end
    """
 
  Scenario: Stubbing methods multiple times
    Then spec file with following content should fail:
    """ruby
    describe Library do
      it "stubbing with too many arguments" do
        library = Library.new

        stub(library).checkout("some book") { :bought }
        stub(library).checkout("book", "and one argument too many") { :whatever }
      end
    end
    """
