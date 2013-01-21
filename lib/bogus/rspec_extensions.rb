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
    def fake(*args)
      Bogus.create_anonymous_stub(*args)
    end

    def stub(*args)
      Bogus.create_stub(*args)
    end

    def have_received(*args)
      Bogus.have_received(*args)
    end

    def mock(*args)
      Bogus.create_mock(*args)
    end

    def any_args
      Bogus::AnyArgs
    end

    def anything
      Bogus::Anything
    end
  end
end

