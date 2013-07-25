module Bogus
  class UndefinedReturnValue
    def initialize(interaction)
      @interaction = InteractionPresenter.new(interaction)
    end

    def to_s
      "#<UndefinedReturnValue for #{@interaction}>"
    end

    def method_missing(name, *args, &block)
      raise NoMethodError, "undefined method '#{name}' for #{self}"
    end
  end
end
