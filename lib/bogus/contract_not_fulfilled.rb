module Bogus
  class ContractNotFulfilled < StandardError
    attr_reader :fake_name, :missed_interactions, :actual_interactions

    def initialize(fake_name, opts = {})
      @fake_name = fake_name
      @actual_interactions = opts.fetch(:actual)
      @missed_interactions = opts.fetch(:missed)
      super(message)
    end

    def message
      str = <<-EOF
      Contract not fullfilled for #{fake_name}!

      Missed interactions:
      #{interactions_str(missed_interactions)}

      Actual interactions:
      #{interactions_str(actual_interactions)}
      EOF
      str.gsub(' ' * 6, '')
    end

    private

    def interactions_str(interactions)
      interactions.map { |i| "  - #{InteractionPresenter.new(i)}" }.join("\n")
    end
  end
end
