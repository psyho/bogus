module Bogus
  class CreatesStubs
    extend Takes
    takes :rr_proxy, :verifies_stub_definition

    def create(object)
      Bogus::Stub.new(object, rr_proxy, verifies_stub_definition)
    end
  end
end
