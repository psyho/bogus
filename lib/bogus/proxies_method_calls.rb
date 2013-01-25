module Bogus
  module ProxiesMethodCalls
    def proxy(method_name)
      MethodCallProxy.new do |name, *args, &return_value|
        __send__(method_name, name, *args, &return_value)
      end
    end
  end

  class MethodCallProxy < BasicObject
    def initialize(&on_called)
      @on_called = on_called
    end

    def raise(*args)
      ::Kernel.raise(*args)
    end

    def method_missing(name, *args, &block)
      @on_called.call(name, *args, &block)
    end
  end
end
