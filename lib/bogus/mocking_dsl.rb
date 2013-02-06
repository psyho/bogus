module Bogus
  module MockingDSL
    def fake(*args, &block)
      Bogus.fake_for(*args, &block)
    end

    def fake_class(name, opts = {})
      Bogus.fake_class(name, opts)
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
