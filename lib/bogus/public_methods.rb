module Bogus
  module PublicMethods

    def fake_for(*args)
      return inject.creates_fakes.create(*args)
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
