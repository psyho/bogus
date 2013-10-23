module Bogus
  class MatchesArgument
    def initialize(&block)
      @block = block
    end

    def ==(argument)
      @block.call(argument)
    end
  end
end
