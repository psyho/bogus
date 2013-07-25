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
end
