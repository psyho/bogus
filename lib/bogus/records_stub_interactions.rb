class Bogus::RecordsStubInteractions
  extend Bogus::Takes

  takes :stubbed_interactions, :fake_registry

  def record(object, method_name, args)
    fake_name = fake_registry.name(object)
    stubbed_interactions.record(fake_name, method_name, *args) if fake_name
  end

end
