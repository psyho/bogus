Feature: Customizing the overwritten class

  Typically, when you specify a contract to be verified, you do it like this:

      describe SomeClass do
        verify_contract(:some_fake_name)
      end

  When you do this, under the hood Bogus replaces `SomeClass` with a proxy that records any calls made to the class and its instances for the duration of the test.

  If the class you want to be overwritten is not the one that is described, you can customize it like so:

      describe "not a class" do
        verify_contract(:some_fake_name) { SomeClass }
      end

  In case there is no described class and you don't provide a custom one to be overwritten, the class will be guessed based on the name of the fake:

      describe "not a class" do
        verify_contract(:some_fake_name)
      end

  In the above example, Bogus will try to overwrite a class named `SomeFakeName`.

  Background:
    Given a file named "library.rb" with:
    """ruby
    class PublicLibrary
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
      def read(book, library = PublicLibrary.new)
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
      fake(:library) { PublicLibrary }

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

  Scenario: Verifying contract for a class that is not the described_class
  Then spec file with following content should pass:
    """ruby
    require_relative 'library'

    describe "Borrowing books from library" do
      verify_contract(:library) { PublicLibrary }

      let(:library) { PublicLibrary.new }

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


