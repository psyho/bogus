require_relative 'syntax'

module Bogus
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

