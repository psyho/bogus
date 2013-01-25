module Bogus
  class FakeConfiguration
    def include?(name)
      fakes.key?(name)
    end

    def fake(name, opts = {}, &block)
      opts = opts.dup
      class_block = opts.delete(:class)
      fakes[name] = FakeDefinition.new(name: name,
                                       opts: opts,
                                       stubs: stubs_hash(&block),
                                       class_block: class_block)
    end

    def evaluate(&block)
      instance_eval(&block)
    end

    def get(name)
      fakes[name]
    end

    private

    def stubs_hash(&block)
      stubs = StubsConfiguration.new(&block)
      stubs.stubs
    end

    def fakes
      @fakes ||= {}
    end
  end

  class FakeDefinition
    attr_reader :name, :class_block, :opts, :stubs

    def initialize(attrs = {})
      @name = attrs[:name]
      @class_block = attrs[:class_block]
      @opts = attrs[:opts] || {}
      @stubs = attrs[:stubs] || {}
    end

    def merge(other)
      FakeDefinition.new(name: other.name,
                        opts: opts.merge(other.opts),
                        stubs: stubs.merge(other.stubs),
                        class_block: other.class_block || class_block)
    end
  end

  class StubsConfiguration
    include ProxiesMethodCalls

    def initialize(&block)
      proxy(:add_stub).instance_eval(&block) if block
    end

    def add_stub(name, value = nil, &block)
      stubs[name] = block || value
    end

    def stubs
      @stubs ||= {}
    end
  end
end
