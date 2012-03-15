module Bogus
  module PublicMethods

    def fake_for(name)
      klass = inject.converts_name_to_class.convert(name)
      return inject.creates_fakes.create(klass)
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
