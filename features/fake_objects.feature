Feature: Faking existing classes

  Bogus makes it easy to create fakes, which behave like a null-object and
  have the same interface as the object being faked.

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

  Scenario: Fakes which are objects
    Given pending
