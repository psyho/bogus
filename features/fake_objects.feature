Feature: Faking existing classes

  Fakes in Bogus are essentially lightweight objects that mimic the original
  object's interface.

  Let's say that we have a `Library` class that is used to manage books and a `Student`,
  who can interact with the `Library` in some way.

  In order to test the `Student` in isolation, we need to replace the `Library`, with some
  test double. Typically, you would do that by creating an anonymous stub/mock object and
  stubbing the required methods on it.

  Using those stubs, you specify the desired interface of the library object.
  
  The problems with that approach start when you change the `Library` class. For example,
  you could rename the `#checkout` method to `#checkout_book`. If you used the standard approach,
  where your stubs are not connected in any way to the real implementation, your tests will
  keep happily passing, even though the collaborator interface just changed.

  Bogus saves you from this problem, because your fakes have the exact same interface as
  the real collaborators, so whenever you change the collaborator, but not the tested object,
  you will get an exception in your tests.

  Background:
    Given a file named "foo.rb" with:
    """ruby
    class Library
      def checkout(book)
      end

      def return_book(book)
      end

      def self.look_up(book)
      end
    end

    class Student
      def self.learn(library = Library.new)
        library.checkout("hello world")
        true
      end
    end
    """

  Scenario: Calling methods that exist on real object
    Then spec file with following content should pass:
    """ruby
    describe Student do
      fake(:library)

      it "does something" do
        Student.learn(library).should be_true
      end
    end
    """

  Scenario: Fakes have null-object semantics
    Then spec file with following content should pass:
    """ruby
    describe "library fake" do
      fake(:library)

      it "returns self from all methods" do
        library.checkout("hello").should == library
      end

      it "makes method chaining possible" do
        library.checkout("hello").return_book("world").should == library
      end
    end
    """

  Scenario: Taking the guesswork out of finding a class to copy
    Then spec file with following content should pass:
    """ruby
    class PublicLibrary
      def checkout(book)
      end
    end

    describe "logger fake" do
      fake(:library) { PublicLibrary }

      it "uses the class provided in block instead of the guessed one" do
        library.class.name.should == "PublicLibrary"
      end
    end
    """

  Scenario: Fakes which are classes
    Then spec file with following content should pass:
    """ruby
    describe "library class fake" do
      fake(:library, as: :class)

      it "is a class" do
        library.should be_a(Class)
      end

      it "has the same name as original class" do
        library.name.should == Library.name
      end

      it "has same methods as original class" do
        library.look_up('something')
      end
    end
    """

  Scenario: Fakes with inline return values
    Then spec file with following content should pass:
    """ruby
    describe "library class fake" do
      let(:library) { fake(:library, checkout: "checked out", 
                                     return_book: "returned") }

      it "sets the default return value for provided functions" do
        library.checkout("Moby Dick").should == "checked out"
        library.checkout("Three Musketeers").should == "checked out"
        library.return_book("Moby Dick").should == "returned"
        library.return_book("Three Musketeers").should == "returned"
      end
    end
    """
