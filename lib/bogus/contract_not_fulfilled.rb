module Bogus
  class ContractNotFulfilled < StandardError
    attr_reader :interactions

    def initialize(interactions)
      @interactions = interactions
      super(message)
    end

    def message
      interactions.map { |fake_name, missed| missed_for_fake(fake_name, missed) }.join("\n")
    end

    private

    def missed_for_fake(fake_name, missed)
      "Contract not fullfilled for #{fake_name}:\n#{missed_interactions(missed)}"
    end

    def missed_interactions(missed)
      missed.map { |i| "  - #{InteractionPresenter.new(i)}" }.join("\n")
    end
  end
end
