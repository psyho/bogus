module Bogus
  class VerifiesContracts
    extend Takes

    takes :doubled_interactions, :real_interactions

    def verify(fake_name)
      missed = doubled_interactions.for_fake(fake_name).reject do |interaction|
        real_interactions.recorded?(fake_name, interaction)
      end

      unless missed.empty?
        actual = real_interactions.for_fake(fake_name)
        raise Bogus::ContractNotFulfilled.new(fake_name, missed: missed, actual: actual)
      end
    end
  end
end
