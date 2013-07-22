require 'forwardable'
require 'bogus/minitest'

module MiniTest::Expectations
  infect_an_assertion :assert_received, :must_have_received, true
  infect_an_assertion :refute_received, :wont_have_received, true
end

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
      if defined? Minitest.after_run
        Minitest.after_run(&block)
      else
        MiniTest::Unit.after_tests(&block)
      end
    end
  end
end

class MiniTest::Spec
  module DSL
    def fake(name, opts = {}, &block)
      let(name) { fake(name, opts, &block) }
    end

    def fake_class(name, opts = {})
      before { fake_class(name, opts) }
    end

    def verify_contract(name, &block)
      syntax = Bogus::MiniTestSyntax.new(self)
      Bogus.add_contract_verification(syntax, name, &block)
    end
  end
end
