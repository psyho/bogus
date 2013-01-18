module Bogus
  class Double
    extend Takes
    include ProxiesMethodCalls

    takes :object, :double_tracker, :verifies_stub_definition,
      :overwrites_methods, :records_double_interactions

    def stub
      proxy(:stubs)
    end

    def stubs(name, *args, &return_value)
      double_tracker.track(object)
      verifies_stub_definition.verify!(object, name, args)
      records_double_interactions.record(object, name, args, &return_value)
      overwrites_methods.overwrite(object, name)
      object.__shadow__.stubs(name, *args, &return_value)
    end

    def mock
      proxy(:mocks)
    end

    def mocks(name, *args, &return_value)
      stubs(name, *args, &return_value)
      object.__shadow__.mocks(name, *args, &return_value)
    end
  end
end
