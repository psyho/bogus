class Bogus::Stub < BasicObject
  def initialize(object, rr_proxy, verifies_stub_definition)
    @object = object
    @stub = rr_proxy.stub(object)
    @verifies_stub_definition = verifies_stub_definition
  end

  def method_missing(name, *args, &block)
    @verifies_stub_definition.verify!(@object, name, args)
    @stub.__send__(name, *args, &block)
  end
end
