module Bogus
  class InteractionPresenter
    extend Takes

    takes :interaction

    def to_s
      "##{interaction.method}(#{args})#{result}"
    end

    private

    def args
      interaction.args.map(&:inspect).join(', ')
    end

    def result
      error || return_value
    end

    def return_value
      " => #{interaction.return_value.inspect}" if interaction.has_result
    end

    def error
      " !! #{interaction.error}" if interaction.error
    end
  end
end
