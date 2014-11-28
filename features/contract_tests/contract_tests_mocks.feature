Feature: Contract tests with mocks

  Whenever you mock something, you specify a contract on the arguments/return value pair.  Bogus can check automatically whether this contract was satisfied.

  Background:
    Given a file named "library.rb" with:
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
    """

    Given a file named "student.rb" with:
    """ruby
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
    require_relative 'student'
    require_relative 'library'

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

        expect(library).not_to have_received.checkout("Moby Dick")
      end
    end
    """

  Scenario: Fails when mocked methods are not called on real object
    Then spec file with following content should fail:
    """ruby
    require_relative 'library'

    describe Library do
      verify_contract(:library)

      let(:library) { Library.new }

      it "marks books as unavailable after they are checked out" do
        library.return("Moby Dick")

        library.checkout("Moby Dick")

        expect(library.has_book?("Moby Dick")).to be(false)
      end
    end
    """

  Scenario: Verifies that mocked methods are called
    Then spec file with following content should pass:
    """ruby
    require_relative 'library'

    describe Library do
      verify_contract(:library)

      let(:library) { Library.new }

      it "allows checking out books that are in the inventory" do
        library.return("Moby Dick")

        expect(library.has_book?("Moby Dick")).to be(true)
      end

      it "does not allow checking out unavailable books" do
        expect(library.has_book?("Moby Dick")).to be(false)
      end

      it "marks books as unavailable after they are checked out" do
        library.return("Moby Dick")

        library.checkout("Moby Dick")

        expect(library.has_book?("Moby Dick")).to be(false)
      end
    end
    """

