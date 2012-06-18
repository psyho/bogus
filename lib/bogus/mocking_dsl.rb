module Bogus
  module MockingDSL
    def injector
      @injector ||= Bogus::Injector.new
    end

    def stub(object)
      injector.create_stub(object)
    end

    def have_received(method = nil)
      injector.invocation_matcher(method)
    end
  end
end
