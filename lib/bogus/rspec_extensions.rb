module Bogus
  module RSpecExtensions
    def fake(name, opts = {}, &block)
      let(name) { Bogus.fake_for(name, opts, &block) }
    end
  end
end
