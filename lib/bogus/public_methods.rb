module Bogus
  module PublicMethods
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
      inject.have_received_matcher(*args)
    end

    def fake_for(*args, &block)
      inject.creates_fakes_with_stubbed_methods.create(*args, &block)
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

    def fakes(&block)
      inject.fake_configuration.evaluate(&block)
    end

    def inject
      @injector ||= Bogus::Injector.new
    end
  end
end
