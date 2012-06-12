module Bogus
  module MockingDSL
    def stub(object)
      injector = Bogus::Injector.new
      injector.creates_stubs.create(object)
    end
  end
end
