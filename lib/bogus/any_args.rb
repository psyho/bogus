module Bogus
  module AnyArgs
    def self.inspect
      "any_args"
    end

    def self.any_args?(args)
      [AnyArgs] == args
    end
  end
end
