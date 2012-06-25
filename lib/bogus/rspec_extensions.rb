module Bogus
  module RSpecExtensions
    def fake(name, opts = {}, &block)
      let(name) { Bogus.fake_for(name, opts, &block) }
    end

    def verify_contract(name)
      before do
        Bogus.record_calls_for(name)
      end

      RSpec.configure do |config|
        config.after(:suite) { Bogus.verify_contract!(name) }
      end
    end
  end

  module MockingDSL
    def stub(object)
      Bogus.create_stub(object)
    end

    def have_received(method = nil)
      Bogus.have_received(method)
    end
  end
end

