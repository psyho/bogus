Feature: Replacing classes with fakes

  Bogus is an opinionated piece of software. One of the opinions we have is that you should use dependency injection to make your code more modular and your classes easier to compose. However, we respect the fact, that this is currently not very popular among Ruby developers.

  In order to make life easier for people who choose not to use Dependency Injection, Bogus makes it convenient to replace chosen classes in your tests with fakes.

  All you need to do, is put the following code in your describe:

      fake_class(FooBar, foo: "bar")

  Which is a shortcut for:

      before do
        fake_class(FooBar, foo: "bar")
      end
  
  Background:
    Given a file named "app.rb" with:
    """ruby
    require "yaml"

    class Library
      FILE =  "library.yml"

      def self.books
        YAML.load_file(FILE)
      end
    end

    class BookIndex
      def self.by_author(author)
        Library.books.select{|book| book[:author] == author}
      end
    end
    """

    And a file named "spec_helper.rb" with:
    """ruby
    require 'bogus/rspec'

    require_relative 'app'
    """

  Scenario: Replacing classes and contracts
    Given a file named "library_spec.rb" with:
    """ruby
    require_relative 'spec_helper'
    require 'fileutils'
    
    describe Library do
      verify_contract(:library)

      it "reads the books from the yaml file" do
        books = [{name: "Tom Sawyer", author: "Mark Twain"}, 
                 {name: "Moby Dick", author: "Herman Melville"}]
        File.open(Library::FILE, "w") { |f| f.print books.to_yaml }

        Library.books.should == books
      end

      after do
        FileUtils.rm_rf(Library::FILE)
      end
    end
    """

    And a file named "book_index_spec.rb" with:
    """ruby
    require_relative 'spec_helper'

    describe BookIndex do
      verify_contract(:book_index)

      it "returns books written by author" do
        tom_sawyer = {name: "Tom Sawyer", author: "Mark Twain"}
        moby_dick = {name: "Moby Dick", author: "Herman Melville"}

        fake_class(Library, books: [tom_sawyer, moby_dick])

        BookIndex.by_author("Mark Twain").should == [tom_sawyer]
      end
    end
    """

    When I run `rspec book_index_spec.rb library_spec.rb`
    Then the specs should pass
    
  Scenario: Replacing classes and contracts with a different fake name
    Given a file named "library_spec.rb" with:
    """ruby
    require_relative 'spec_helper'
    require 'fileutils'
    
    describe Library do
      verify_contract(:book_repository)

      it "reads the books from the yaml file" do
        books = [{name: "Tom Sawyer", author: "Mark Twain"}, 
                 {name: "Moby Dick", author: "Herman Melville"}]
        File.open(Library::FILE, "w") { |f| f.print books.to_yaml }

        Library.books.should == books
      end

      after do
        FileUtils.rm_rf(Library::FILE)
      end
    end
    """

    And a file named "book_index_spec.rb" with:
    """ruby
    require_relative 'spec_helper'

    describe BookIndex do
      verify_contract(:book_index)

      it "returns books written by author" do
        tom_sawyer = {name: "Tom Sawyer", author: "Mark Twain"}
        moby_dick = {name: "Moby Dick", author: "Herman Melville"}

        fake_class(Library, fake_name: :book_repository,
                            books: [tom_sawyer, moby_dick])

        BookIndex.by_author("Mark Twain").should == [tom_sawyer]
      end
    end
    """

    When I run `rspec book_index_spec.rb library_spec.rb`
    Then the specs should pass

  Scenario: Replacing classes with a macro
    Given a file named "book_index_spec.rb" with:
    """ruby
    require_relative 'spec_helper'

    describe BookIndex do
      fake_class(Library, books: [])

      it "returns books written by author" do
        BookIndex.by_author("Mark Twain").should == []
      end
    end
    """

    When I run `rspec book_index_spec.rb`
    Then the specs should pass
