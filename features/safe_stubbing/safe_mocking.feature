Feature: Safe mocking

  In Bogus you normally use the following pattern to make sure right messages were sent between the tested object and it's collaborators:

  1. Stub the collaborator method in let or before
  2. In one test ensure that the tested method returns the right thing
  3. In another test use `have_received` to ensure that the method on collaborator was called with right arguments.

  However, there are cases when the more general stub in let or before is not enough. Then, we can use mocking to reduce the amount of code written.

  The syntax for mocking is:

      mock(object).method_name(*args) { return_value }

  You can only mock methods that actually exist on an object. It will also work with methods that the object `responds_to?`, but (obviously) without being able to check the method signature.

  Background:
    Given a file named "library.rb" with:
    """ruby
    class Library
      def checkout(book)
      end
    end
    """

  Scenario: Mocking methods that exist on real object
    Then spec file with following content should pass:
    """ruby
    require_relative 'library'

    describe Library do
      it "does something" do
        library = Library.new
        mock(library).checkout("some book") { :checked_out }

        expect(library.checkout("some book")).to eq(:checked_out)
      end
    end
    """

  Scenario: Mocking methods that do not exist on real object
    Then spec file with following content should fail:
    """ruby
    require_relative 'library'
    
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
    require_relative 'library'

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
    require_relative 'library'

    describe Library do
      it "does something" do
        library = Library.new
        mock(library).checkout("some book") { :bought }
      end
    end
    """
