module Bogus
  class RespondsToEverything
    def respond_to?(method)
      true
    end

    def method_missing(name, *args, &block)
      self
    end
  end
end
