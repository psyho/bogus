module Bogus
  module RSpecExtensions
    def fake(name, opts = {})
      let(name) { Bogus.fake_for(name, opts) }
    end
  end
end
