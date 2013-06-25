require 'bogus/minitest'

module MiniTest::Expectations
  infect_an_assertion :assert_received, :must_have_received, true
  infect_an_assertion :refute_received, :wont_have_received, true
end

class MiniTest::Spec
  module DSL
    def fake(name, opts = {}, &block)
      let(name) { fake(name, opts, &block) }
    end
  end
end
