module Bogus
  class UndefinedReturnValue
    def initialize(interaction)
      @interaction = InteractionPresenter.new(interaction)
    end

    def to_s
      "#<UndefinedReturnValue for #{@interaction}>"
    end
  end
end
