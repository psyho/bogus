module Bogus
  class RecordsDoubleInteractions
    extend Takes

    takes :doubled_interactions, :fake_registry

    def record(object, method_name, args, &block)
      fake_name = fake_registry.name(object)
      doubled_interactions.record(fake_name, method_name, *args, &block) if fake_name
    end
  end
end
