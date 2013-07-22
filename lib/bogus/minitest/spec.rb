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

    def fake_class(name, opts = {})
      before { fake_class(name, opts) }
    end

    def verify_contract(name)
      @old_desc = @desc

      before { @desc = Bogus.record_calls_for(name, @desc) }
      after { @desc = @old_desc }

      # minitest 5 vs 4.7
      if defined? Minitest.after_run
        Minitest.after_run { Bogus.verify_contract!(name) }
      else
        MiniTest::Unit.after_tests { Bogus.verify_contract!(name) }
      end
    end
  end
end
