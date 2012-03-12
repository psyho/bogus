module Bogus
  module RSpecExtensions
    def fake(name)
      let(name) { Bogus.fake_for(name) }
    end
  end
end
