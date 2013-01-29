Feature: Contract tests with stubs

  Whenever you stub any method, a contract is specified on the input/output values of that method.

  When stubbing using the short syntax:

      fake(:fake_name, method_name: :return_value)

  the contract can only be specified on the return value.

  The longer syntax:

      stub(fake).method_name(args) { :return_value }

  will also create a contract on the method input parameters.

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
        stub(library).has_book?("Moby Dick") { true }

        student.read("Moby Dick", library)

        library.should have_received.checkout("Moby Dick")
      end

      it "does not check out the book from library if not available" do
        student = Student.new
        stub(library).has_book?("Moby Dick") { false }

        student.read("Moby Dick", library)

        library.should_not have_received.checkout("Moby Dick")
      end
    end
    """

  Scenario: Fails when stubbed methods are not called on real object
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

  Scenario: Verifies that stubbed methods are called
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
