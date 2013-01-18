Feature: Contract tests with mocks

  Background:
    Given a file named "foo.rb" with:
    """ruby
    class Library
      def initialize
        @books = []
      end

      def has_book?(book)
        @books.include?(book)
      end

      def checkout(book)
        @books.delete(book)
      end

      def return(book)
        @books << book
      end
    end

    class Student
      def read(book, library = Library.new)
        if library.has_book?(book)
          library.checkout(book)
        end
      end
    end
    """
    And a spec file named "student_spec.rb" with:
    """ruby
    describe Student do
      fake(:library)

      it "checks out the book from library if it is available" do
        student = Student.new
        mock(library).has_book?("Moby Dick") { true }
        mock(library).checkout("Moby Dick") { "Moby Dick" }

        student.read("Moby Dick", library)
      end

      it "does not check out the book from library if not available" do
        student = Student.new
        mock(library).has_book?("Moby Dick") { false }

        student.read("Moby Dick", library)

        library.should_not have_received.checkout("Moby Dick")
      end
    end
    """

  Scenario: Fails when mocked methods are not called on real object
    Then spec file with following content should fail:
    """ruby
    describe Library do
      verify_contract(:library)

      let(:library) { Library.new }

      it "marks books as unavailable after they are checked out" do
        library.return("Moby Dick")

        library.checkout("Moby Dick")

        library.has_book?("Moby Dick").should be_false
      end
    end
    """

  Scenario: Verifies that mocked methods are called
    Then spec file with following content should pass:
    """ruby
    describe Library do
      verify_contract(:library)

      let(:library) { Library.new }

      it "allows checking out books that are in the inventory" do
        library.return("Moby Dick")

        library.has_book?("Moby Dick").should be_true
      end

      it "does not allow checking out unavailable books" do
        library.has_book?("Moby Dick").should be_false
      end

      it "marks books as unavailable after they are checked out" do
        library.return("Moby Dick")

        library.checkout("Moby Dick")

        library.has_book?("Moby Dick").should be_false
      end
    end
    """

