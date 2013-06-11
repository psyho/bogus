module Bogus
  class Configuration
    attr_writer :search_modules
    attr_accessor :fake_ar_attributes

    def search_modules
      @search_modules ||= [Object]
    end
  end
end
