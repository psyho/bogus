class Bogus::VerifiesContracts
  extend Bogus::Takes

  takes :stubbed_interactions, :real_interactions

  def verify(fake_name)
    stubbed_interactions.for_fake(fake_name).each do |interaction|
      unless real_interactions.recorded?(fake_name, interaction)
        raise Bogus::ContractNotFulfilled
      end
    end
  end
end
