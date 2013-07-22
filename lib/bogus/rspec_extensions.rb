require 'forwardable'

module Bogus
  class RSpecSyntax
    extend Takes
    extend Forwardable
    takes :context
    def_delegators :context, :before, :after, :described_class

    def described_class=(value)
      context.example.metadata[:example_group][:described_class] = value
    end

    def after_suite(&block)
      RSpec.configure do |config|
        config.after(:suite, &block)
      end
    end
  end

  module RSpecExtensions
    def fake(name, opts = {}, &block)
      let(name) { fake(name, opts, &block) }
    end

    def fake_class(name, opts = {})
      before do
        fake_class(name, opts)
      end
    end

    def verify_contract(name, &block)
      syntax = RSpecSyntax.new(self)
      Bogus.add_contract_verification(syntax, name, &block)
    end
  end
end

