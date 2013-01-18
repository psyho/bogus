module Bogus
  module PublicMethods

    def fake_for(*args, &block)
      inject.creates_fakes.create(*args, &block)
    end

    def record_calls_for(name)
      inject.adds_recording.add(name)
    end

    def verify_contract!(fake_name)
      inject.verifies_contracts.verify(fake_name)
    end

    def configure(&block)
      config.tap(&block)
    end

    def config
      inject.configuration
    end

    def reset!
      @injector = Bogus::Injector.new
    end

    def create_stub(*args)
      inject.create_stub(*args)
    end

    def create_mock(*args)
      inject.create_mock(*args)
    end

    def have_received(*args)
      inject.invocation_matcher(*args)
    end

    def create_anonymous_stub(*args)
      inject.creates_anonymous_stubs.create(*args)
    end

    def after_each_test
      ensure_all_expectations_satisfied!
      reset_stubbed_methods
      clear_expectations
    end

    def setup_mocks_for_rspec
    end

    def verify_mocks_for_rspec
    end

    def teardown_mocks_for_rspec
    end

    def ensure_all_expectations_satisfied!
      doubles = inject.double_tracker.doubles
      inject.ensures_all_interactions_satisfied.ensure_satisfied!(doubles)
    end

    def clear_expectations
      inject.clear_tracked_doubles
    end

    def reset_stubbed_methods
      inject.resets_stubbed_methods.reset_all_doubles
    end

    def inject
      @injector ||= Bogus::Injector.new
    end
  end
end
