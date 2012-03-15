module Bogus
  class Configuration
    attr_writer :search_modules

    def search_modules
      @search_modules ||= [Object]
    end
  end
end
