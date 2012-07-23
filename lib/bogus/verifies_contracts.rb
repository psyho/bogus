class Bogus::VerifiesContracts
  extend Bogus::Takes

  takes :doubled_interactions, :real_interactions

  def verify(fake_name)
    doubled_interactions.for_fake(fake_name).each do |interaction|
      unless real_interactions.recorded?(fake_name, interaction)
        raise Bogus::ContractNotFulfilled, "Missing interaction with #{fake_name}: #{interaction.inspect}"
      end
    end
  end
end
