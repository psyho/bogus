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
      if include?(name)
        fake = fakes[name]
        [fake.opts_with_stubs, fake.class_block]
      end
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
    attr_reader :name, :class_block, :opts

    def initialize(attrs = {})
      @name = attrs[:name]
      @class_block = attrs[:class_block]
      @opts = attrs[:opts] || {}
      @stubs = attrs[:stubs] || {}
    end

    def opts_with_stubs
      opts.merge(stubs)
    end

    def stubs
      Hash[@stubs.map{|name, block| [name, block.call]}]
    end
  end

  class StubsConfiguration
    include ProxiesMethodCalls

    def initialize(&block)
      proxy(:add_stub).instance_eval(&block) if block
    end

    def add_stub(name, value = nil, &block)
      stubs[name] = block || proc{value}
    end

    def stubs
      @stubs ||= {}
    end
  end
end
