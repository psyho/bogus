class Bogus::VerifiesContracts
  extend Bogus::Takes

  takes :doubled_interactions, :real_interactions

  def verify(fake_name)
    missed = doubled_interactions.for_fake(fake_name).reject do |interaction|
      real_interactions.recorded?(fake_name, interaction)
    end
    raise Bogus::ContractNotFulfilled.new(fake_name => missed) unless missed.empty?
  end
end
