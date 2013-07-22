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

    def verify_contract(name, &block)
      old_desc = @desc
      custom_class = block.call if block_given?
      verified_class = custom_class || @desc

      before do
        new_class = Bogus.record_calls_for(name, verified_class)
        @desc = new_class unless custom_class
      end

      after { @desc = old_desc unless custom_class }

      # minitest 5 vs 4.7
      if defined? Minitest.after_run
        Minitest.after_run { Bogus.verify_contract!(name) }
      else
        MiniTest::Unit.after_tests { Bogus.verify_contract!(name) }
      end
    end
  end
end
