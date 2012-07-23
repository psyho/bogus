Feature: Safe mocking

  Background:
    Given a file named "foo.rb" with:
    """ruby
    class Library
      def checkout(book)
      end
    end
    """

  Scenario: Mocking methods that exist on real object
    Then spec file with following content should pass:
    """ruby
    describe Library do

      it "does something" do
        library = Library.new
        mock(library).checkout("some book") { :checked_out }

        library.checkout("some book").should == :checked_out
      end
    end
    """

  Scenario: Mocking methods that do not exist on real object
    Then spec file with following content should fail:
    """ruby
    describe Library do
      it "does something" do
        library = Library.new
        mock(library).buy("some book") { :bought }
        library.buy("some book")
      end
    end
    """

  Scenario: Mocking methods with wrong number of arguments
    Then spec file with following content should fail:
    """ruby
    describe Library do
      it "does something" do
        library = Library.new
        mock(library).checkout("some book", "another book") { :bought }
        library.checkout("some book", "another book")
      end
    end
    """

  Scenario: Mocks require the methods to be called
    Then spec file with following content should fail:
    """ruby
    describe Library do
      it "does something" do
        library = Library.new
        mock(library).checkout("some book") { :bought }
      end
    end
    """
