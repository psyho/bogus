class Bogus::Stub < BasicObject
  def initialize(object, rr_proxy, verifies_stub_definition, records_stub_interactions)
    @object = object
    @stub = rr_proxy.stub(object)
    @verifies_stub_definition = verifies_stub_definition
    @records_stub_interactions = records_stub_interactions
  end

  def method_missing(name, *args, &block)
    @verifies_stub_definition.verify!(@object, name, args)
    @records_stub_interactions.record(@object, name, args, &block)
    @stub.__send__(name, *args, &block)
  end
end
