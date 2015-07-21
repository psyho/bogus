require 'forwardable'

module Bogus
  class MiniTestSyntax
    extend Takes
    extend Forwardable
    takes :context
    def_delegators :context, :before, :after

    def described_class
      return context.desc if context.desc.is_a?(Module)
    end

    def described_class=(value)
      context.instance_variable_set('@desc', value)
    end

    def after_suite(&block)
      # minitest 5 vs 4.7
      if defined? ::Minitest.after_run
        ::Minitest.after_run(&block)
      else
        MiniTest::Unit.after_tests(&block)
      end
    end
  end
end
