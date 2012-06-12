Feature: Safe stubbing

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

  Scenario: Stubbing methods that does not exist on real object
    Then spec file with following content should fail:
    """ruby
    describe Library do
      it "does something" do
        library = Library.new
        stub(library).buy("some book") { :bought }
      end
    end
    """
