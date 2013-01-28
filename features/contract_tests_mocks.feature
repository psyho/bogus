Feature: Contract tests with mocks

  Whenever you write test code like this:

      mock(library).checkout("Moby Dick") { raise NoSuchBookError }

  There are some assumptions this code makes:

  1. There is an object in my system that can play the role of a library.
  2. The library object has a `#checkout` method that takes one argument.
  3. The system under test is supposed to call `#checkout` with argument `"Moby Dick"` at least once.
  4. There is some context in which, given argument "Moby Dick", the `#checkout`
     method raises `NoSuchBookError`.

  While using fakes makes sure that the assumptions 1 and 2 are satisfied, and assumption
  number 3 is verified by the mocking system, in order to make sure that the assumption no 4 
  is also true, you need to write a test for the library object.

  Bogus will not be able to write that test for you, but it can remind you that you should do so.

  Whenever you use named fakes:

      fake(:library)

  Bogus will remember any interactions set up on that fake.

  If you want to verify that you remembered to test all the scenarios specified by stubbing/spying/mocking 
  on the fake object, you can put the following code in the tests for "the real thing" (i.e. the Library class
  in our example):

      verify_contract(:library)
  
  This will record all of the interactions you make with that class and make the tests fail if you forget
  to test some scenario that you recorded using a fake object.

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

