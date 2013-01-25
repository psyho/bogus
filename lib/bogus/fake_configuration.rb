module Bogus
  class FakeConfiguration
    include ProxiesMethodCalls

    def include?(name)
      fakes.key?(name)
    end

    def configure_fake(name, opts, &class_block)
      fakes[name] = [opts, class_block]
    end

    def evaluate(&block)
      proxy(:configure_fake).instance_eval(&block)
    end

    def get(name)
      fakes[name]
    end

    private

    def fakes
      @fakes ||= {}
    end
  end
end
