Feature: Anonymous test doubles

  Anonymous test doubles can be useful as a stepping stone towards actual fakes and when migrating from another testing library.

  In contrast with other testing libraries, Bogus makes it's fakes respond to all methods by default and makes those calls chainable.  This way you can spy on methods without stubbing them first.

  It is not advisable to use those for anything else than an intermediate step.  Fakes that mimic an actual class have many more benefits.

  The syntax for defining fakes is:

      fake(method_1: return_value, method_2: proc{return_value2})

  If you pass a proc as a return value to a fake, the proc will be called to obtain the value.  This can be used for instance to raise errors in stubbed methods.

  If you want to actually return a proc from a method, you need to use a slightly longer syntax:

      factory = fake()
      stub(factory).make_validator{ proc{ false } }

  Background:
    Given a file named "foo.rb" with:
    """ruby
    class Student
      attr_reader :library_card

      def initialize(name)
        @name = name
      end

      def sign_up(library)
        @library_card = library.register_junior(@name)
      end
    end
    """

  Scenario: Stubbing any method with any parameters
    Then spec file with following content should pass:
    """ruby
    describe Student do
      let(:library) { fake }
      let(:jake) { Student.new("Jake") }
      
      it "allows stubbing any method with any parameters" do
        stub(library).register_junior(any_args) { "the card" }

        jake.sign_up(library)

        jake.library_card.should == "the card"
      end
    end
    """

  Scenario: Stubbing methods in initializer
    Then spec file with following content should pass:
    """ruby
    describe Student do
      let(:library) { fake(register_junior: "the card") }
      let(:jake) { Student.new("Jake") }
      
      it "allows stubbing any method with any parameters" do
        jake.sign_up(library)

        jake.library_card.should == "the card"
      end
    end
    """

  Scenario: Stubbing methods inline by passing a block
    Then the following test should pass:
    """ruby
    library = fake(register_junior: proc{ raise "library full!" })
    expect {
      library.register_junior("Jake")
    }.to raise_error("library full!")
    """

  Scenario: Mocking any method with any parameters
    Then spec file with following content should pass:
    """ruby
    describe Student do
      let(:library) { fake }
      let(:jake) { Student.new("Jake") }
      
      it "allows stubbing any method with any parameters" do
        mock(library).register_junior("Jake") { "the card" }

        jake.sign_up(library)

        jake.library_card.should == "the card"
      end
    end
    """

  Scenario: Mocking any method with any parameters
    Then spec file with following content should fail:
    """ruby
    describe Student do
      it "allows stubbing any method with any parameters" do
        library = fake
        mock(library).register_junior { "the card" }
      end
    end
    """

  Scenario: Stubbing methods in initializer
    Then spec file with following content should pass:
    """ruby
    describe Student do
      let(:library) { fake(register_junior: "the card") }
      let(:jake) { Student.new("Jake") }
      
      it "allows stubbing any method with any parameters" do
        jake.sign_up(library)

        jake.library_card.should == "the card"
      end
    end
    """

  Scenario: Spying on method calls
    Then spec file with following content should pass:
    """ruby
    describe Student do
      let(:library) { fake }
      let(:jake) { Student.new("Jake") }
      
      it "allows stubbing any method with any parameters" do
        jake.sign_up(library)

        library.should have_received.register_junior("Jake")
      end
    end
    """

  Scenario: Invoking arbitrary methods
    Then spec file with following content should pass:
    """ruby
    describe Student do
      let(:library) { fake }
      
      it "allows stubbing any method with any parameters" do
        library.foo.bar("hello").baz.should == library
      end
    end
    """
