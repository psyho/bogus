module Bogus
  class InteractionsRepository
    def initialize
      @interactions = Hash.new { |hash, fake_name| hash[fake_name] = [] }
    end

    def record(fake_name, method, *args)
      @interactions[fake_name] << Interaction.new(method, args)
    end

    def recorded?(fake_name, interaction)
      @interactions[fake_name].include?(interaction)
    end

    def for_fake(fake_name)
      @interactions[fake_name]
    end
  end
end
