Feature: Faking duck types

  Sometimes, your system contains more than one class that can satisfy a given role. Which of the possible implementations do you pick then, and how can you make sure that their interfaces stay in sync?

  Bogus gives you a way of extracting the "lowest common interface" out of multiple classes. All you need to do is just pass the classes in question to the `make_duck` method:

  make_duck(DatabaseLogger, NetworkLogger, DevNullLogger)

  This call will return a new class, that contains only the methods that exist in the public interface of all of the given classes, and in all of them have the same signature.

  Background:
    Given a file named "foo.rb" with:
    """ruby
    class DatabaseLogger
      def debug(message); end
      def warn(message, level); end
      def connection; end
    end

    class NetworkLogger
      def debug(message); end
      def warn(message, level); end
      def socket; end
    end

    class DevNullLogger
      def debug(message); end
      def warn(message, level); end
      def error(message); end
    end
    """

  Scenario: Copying instance methods
    Then spec file with following content should pass:
    """ruby
    describe "make_duck" do
      let(:duck) { make_duck(DatabaseLogger, NetworkLogger, 
                            DevNullLogger) }
      let(:duck_instance) { duck.new }

      it "responds to debug" do
        duck_instance.should respond_to(:debug)
      end

      it "has arity 1 for debug" do
        duck_instance.method(:debug).arity.should == 1
      end

      it "responds to warn" do
        duck_instance.should respond_to(:warn)
      end

      it "has arity 2 for warn" do
        duck_instance.method(:warn).arity.should == 2
      end

      it "does not respond to connection" do
        duck_instance.should_not respond_to(:connection)
      end

      it "does not respond to socket" do
        duck_instance.should_not respond_to(:socket)
      end

      it "does not respond to error" do
        duck_instance.should_not respond_to(:error)
      end
    end
    """
