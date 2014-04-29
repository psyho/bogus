Feature: Global fake configuration

  In an ideal world, all the fakes would follow the tell-don't-ask principle, which would eliminate the need for stubbing, and would be instances of classes that match the fake name, which would eliminate the need for configuration of things like (`as: :class` / `as: :instance`).

  However, in reality we often need to add this kind of configuration to our fake definitions, and the more collaborators a fake has, the more duplication we introduce this way.

  To eliminate this duplication, Bogus comes with a DSL to configure the fakes in one place, and unify their use in all your tests.

  To globally configure your fakes, all you need to do is to place code like this:

      Bogus.fakes do
        fake(:fake_name, as: :class, class: proc{SomeClass}) do
          method_1 { return_value_1 } 
          method_2 return_value_2
        end
      end

  in your spec helper, or a file required from it.

  Background:
    Given a file named "public_library.rb" with:
    """ruby
    class PublicLibrary
      def self.books_by_author(name)
      end
    end
    """

    Given a file named "fakes.rb" with:
    """ruby
    Bogus.fakes do
      fake(:library, as: :class, class: proc{PublicLibrary}) do
        books_by_author []
      end
    end
    """

  Scenario: Globally configured fakes have all the properties configured
    Then spec file with following content should pass:
    """ruby
    require_relative "fakes"
    require_relative "public_library"

    describe "The library fake" do
      fake(:library)

      it "is a class" do
        # because of the as: :class specified in the fake definition
        expect(library).to be_an_instance_of(Class)
      end

      it "is a copy of PublicLibrary" do
        # because of the block passed into configuration
        expect(library.name).to eq("PublicLibrary")
      end

      it "returns has stubbed books_by_author" do
        # because of the inline-stubbed books_by_author
        expect(library.books_by_author("Mark Twain")).to eq([])
      end
    end
    """

  Scenario: Overwriting stubbed methods using fake macro
    Then spec file with following content should pass:
    """ruby
    require_relative "fakes"
    require_relative "public_library"

    describe "The library fake" do
      fake(:library, books_by_author: ["Some Book"])

      it "can be overridden in the shortcut definition" do
        expect(library.books_by_author("Charles Dickens")).to eq(["Some Book"])
      end
    end
    """

  Scenario: Overwriting stubbed methods using fake helper function
    Then spec file with following content should pass:
    """ruby
    require_relative "fakes"
    require_relative "public_library"

    describe "The library fake" do
      it "can be overridden in the helper" do
        library = fake(:library, books_by_author: ["Some Book"])
        expect(library.books_by_author("Charles Dickens")).to eq(["Some Book"])
      end
    end
    """
