module Bogus
  class MultiStubber
    extend Takes
    takes :create_double

    def stub_all(object, methods = {})
      double = create_double.call(object)
      methods.each do |name, result|
        double.stubs(name, Bogus::AnyArgs) { result }
      end
      object
    end
  end
end
