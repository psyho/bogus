require 'bogus/minitest'

require_relative 'syntax'

module MiniTest::Expectations
  infect_an_assertion :assert_received, :must_have_received, true
  infect_an_assertion :refute_received, :wont_have_received, true
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
