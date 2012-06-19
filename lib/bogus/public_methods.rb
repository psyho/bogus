module Bogus
  module PublicMethods

    def fake_for(*args, &block)
      inject.creates_fakes.create(*args, &block)
    end

    def record_calls_for(name)
      inject.adds_recording.add(name)
    end

    def verify_contract!(fake_name)
      inject.verifies_contracts.verify(fake_name)
    end

    def configure(&block)
      config.tap(&block)
    end

    def config
      inject.configuration
    end

    def reset!
      @injector = Bogus::Injector.new
    end

    private

    def inject
      @injector ||= Bogus::Injector.new
    end
  end
end
