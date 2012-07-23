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
      stub = rr_proxy.stub(object)
      inject(Bogus::Double, object: object, double: stub)
    end

    def create_mock(object)
      mock = rr_proxy.mock(object)
      inject(Bogus::Double, object: object, double: mock)
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

    def doubled_interactions
      @doubled_interactions ||= inject(Bogus::InteractionsRepository)
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
