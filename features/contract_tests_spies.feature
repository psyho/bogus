Feature: Contract tests with spies

  Background:
    Given a file named "foo.rb" with:
    """ruby
    class Library
      def checkout(book)
      end
    end

    class Student
      def read(book, library = Libarary.new)
        library.checkout(book)
        # ...
      end
    end
    """
    And a spec file named "student_spec.rb" with:
    """ruby
    describe Student do
      fake(:library)

      it "reads books from library" do
        student = Student.new

        student.read("Moby Dick", library)

        library.should have_received.checkout("Moby Dick")
      end
    end
    """

  Scenario: Stubbing methods that exist on real object
    Then spec file with following content should pass:
    """ruby
    describe Library do
      verify_contract(:library)

      it "checks out books" do
        library = Library.new

        library.checkout("Moby Dick")

        # ...
      end
    end
    """

  Scenario: Verifing that stubbed methods are tested
    Then spec file with following content should fail:
    """ruby
    describe Library do
      verify_contract(:library)

    end
    """

  Scenario: Verifying that methods are tested with right arguments
    Then spec file with following content should fail:
    """ruby
    describe Library do
      verify_contract(:library)

      it "checks out books" do
        library = Library.new

        library.checkout("Moby Dick 2: The ulitmate")

        # ...
      end
    end
    """
