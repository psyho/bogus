Feature: Faking duck types

  Sometimes, your system contains more than one class that can satisfy a given role. Which of the possible implementations do you pick then, and how can you make sure that their interfaces stay in sync?

  Bogus gives you a way of extracting the "lowest common interface" out of multiple classes. All you need to do is just pass the classes in question to the `make_duck` method:

      make_duck(DatabaseLogger, NetworkLogger, DevNullLogger)

  This call will return a new class, that contains only the methods that exist in the public interface of all of the given classes, and in all of them have the same signature.

  To make things easier for you, Bogus will automatically make a duck type for you, every time you return multiple classes from fake:

      fake(:logger) { [DatabaseLogger, NetworkLogger, DevNullLogger] }

  It is of course also possible to do the same thing in the global fake configuration:

      Bogus.fakes do
        fake :logger, class: proc{ 
          [DatabaseLogger, NetworkLogger, DevNullLogger]
        }
      end

  Background:
    Given a file named "loggers.rb" with:
    """ruby
    class DatabaseLogger
      def error(message); end
      def warn(message, level); end
      def connection; end
    end

    class NetworkLogger
      def error(message); end
      def warn(message, level); end
      def socket; end
    end

    class DevNullLogger
      def error(message); end
      def warn(message, level); end
      def debug(message); end
    end

    class ExceptionNotifier
      def initialize(logger)
        @logger = logger
      end

      def notify(exception)
        @logger.error(exception)
      end
    end

    """

  Scenario: Copying instance methods
    Then spec file with following content should pass:
    """ruby
    require_relative 'loggers'

    describe "make_duck" do
      let(:duck) { make_duck(DatabaseLogger, NetworkLogger, 
                            DevNullLogger) }
      let(:duck_instance) { duck.new }

      it "responds to error" do
        expect(duck_instance).to respond_to(:error)
      end

      it "has arity 1 for error" do
        expect(duck_instance.method(:error).arity).to eq(1)
      end

      it "responds to warn" do
        expect(duck_instance).to respond_to(:warn)
      end

      it "has arity 2 for warn" do
        expect(duck_instance.method(:warn).arity).to eq(2)
      end

      it "does not respond to connection" do
        expect(duck_instance).not_to respond_to(:connection)
      end

      it "does not respond to socket" do
        expect(duck_instance).not_to respond_to(:socket)
      end

      it "does not respond to debug" do
        expect(duck_instance).not_to respond_to(:debug)
      end
    end
    """

  Scenario: Faking duck types
    Then spec file with following content should pass:
    """ruby
    require_relative 'loggers'

    describe "fake with multiple classes" do
      fake(:logger) { [DatabaseLogger, 
                      NetworkLogger, 
                      DevNullLogger] }

      let(:notifier) { ExceptionNotifier.new(logger) }

      it "logs the exception" do
        notifier.notify("whoa!")

        expect(logger).to have_received.error("whoa!")
      end
    end
    """

  Scenario: Globally configured duck types
    Given a file named "fakes.rb" with:
    """ruby
    Bogus.fakes do
      logger_implementations = proc{ [DatabaseLogger, 
                                      NetworkLogger, 
                                      DevNullLogger] }

      fake :logger, class: logger_implementations
    end
    """

    Then spec file with following content should pass:
    """ruby
    require_relative 'fakes'
    require_relative 'loggers'

    describe "fake with multiple classes" do
      fake(:logger)

      let(:notifier) { ExceptionNotifier.new(logger) }

      it "logs the exception" do
        notifier.notify("whoa!")

        expect(logger).to have_received.error("whoa!")
      end
    end
    """
