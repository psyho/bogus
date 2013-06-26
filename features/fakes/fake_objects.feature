Feature: Faking existing classes

  You create a fake by calling the `fake` method:

      fake(fake_name, options) { ClassToCopy }

  If you omit the fake_name, you will get an anonymous fake, otherwise the name will be used to identify the fake for the purposes of contract tests. If you omit the block returning the class to copy, fake name will also be used to guess that.

  Usually you will want the fake to return an instance of the copied class.  Otherwise, you can pass `:as => :class` option to copy the class and return the copy, not an instance of it.

  Options can also include methods to stub on the returned fake, which makes:

      fake(:foo, bar: "value")

  Equivalent to:

      foo = fake(:foo)
      stub(foo).bar(any_args) { "value" }

  For your convenience, Bogus also defines the following macro:

      fake(:foo, bar: "value")

  Which is equivalent to:

      let(:foo) { fake(:foo, bar: "value") }

  Background:
    Given a file named "library.rb" with:
    """ruby
    class Library
      def checkout(book)
      end

      def return_book(book)
      end

      def self.look_up(book)
      end
    end
    """

    Given a file named "student.rb" with:
    """ruby
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
    require_relative 'student'
    require_relative 'library'

    describe Student do
      fake(:library)

      it "does something" do
        Student.learn(library).should be_true
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
    require_relative 'library'

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
    require_relative 'library'

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
