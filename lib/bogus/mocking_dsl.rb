module Bogus
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
