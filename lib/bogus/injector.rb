module Bogus
  class Injector
    include Dependor::AutoInject
    look_in_modules Bogus

    def configuration
      @configuration ||= Bogus::Configuration.new
    end

    def search_modules
      configuration.search_modules
    end

    def rr_proxy
      Bogus::RRProxy
    end

    def fake_registry
      @fake_registry ||= inject(Bogus::FakeRegistry)
    end

    def creates_fakes
      creates_fakes = inject(Bogus::CreatesFakes)
      inject(Bogus::RegistersCreatedFakes, creates_fakes: creates_fakes)
    end

    def create_stub(object)
      inject(Bogus::Stub, object: object)
    end

    def invocation_matcher(method = nil)
      inject(Bogus::InvocationMatcher, method: method)
    end

    def interactions_repository
      raise "Specify either real_interactions or stubbed_interactions"
    end

    def real_interactions
      @real_interactions ||= inject(Bogus::InteractionsRepository)
    end

    def stubbed_interactions
      @stubbed_interactions ||= inject(Bogus::InteractionsRepository)
    end

    def create_proxy_class(fake_name, klass)
      inject(Bogus::ProxyClass, fake_name: fake_name, klass: klass)
    end

    def create_recording_proxy(instance, fake_name)
      inject(Bogus::RecordingProxy,
        instance: instance,
        fake_name: fake_name,
        interactions_repository: real_interactions)
    end
  end
end
