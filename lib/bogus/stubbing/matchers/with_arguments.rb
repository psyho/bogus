module Bogus
  class WithArguments
    attr_reader :predicate

    def initialize(&predicate)
      @predicate = predicate
    end

    def matches?(args)
      predicate.call(*args)
    end

    def self.matches?(opts = {})
      stubbed = opts.fetch(:stubbed)
      recorded = opts.fetch(:recorded)
      return false unless with_matcher?(stubbed)
      return extract(stubbed).matches?(recorded)
    end

    def self.with_matcher?(args)
      args.first.is_a?(WithArguments)
    end

    private

    def self.extract(args)
      args.first
    end
  end
end
