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

    def create_stub(object)
      inject(Bogus::Stub, object: object)
    end

    def invocation_matcher(method = nil)
      inject(Bogus::InvocationMatcher, method: method)
    end
  end
end
