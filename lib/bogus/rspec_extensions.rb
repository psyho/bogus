module Bogus
  module RSpecExtensions
    def fake(name, opts = {}, &block)
      let(name) { Bogus.fake_for(name, opts, &block) }
    end

    def verify_contract(name)
    end
  end
end
