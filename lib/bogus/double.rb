class Bogus::Double < BasicObject
  extend ::Bogus::Takes
  takes :object, :double, :verifies_stub_definition, :records_double_interactions

  def method_missing(name, *args, &block)
    @verifies_stub_definition.verify!(@object, name, args)
    @records_double_interactions.record(@object, name, args, &block)
    @double.__send__(name, *args, &block)
  end
end
