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
  end
end
