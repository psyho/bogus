module Bogus
  class MultiStubber
    extend Takes
    takes :create_double

    def stub_all(object, methods = {})
      double = create_double.call(object)
      methods.each do |name, result|
        block = result.is_a?(Proc) ? result : proc{ result }
        double.stubs(name, Bogus::AnyArgs, &block)
      end
      object
    end
  end
end
