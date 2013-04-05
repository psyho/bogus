module Bogus
  module PublicMethods
    def record_calls_for(name, klass = nil)
      inject.adds_recording.add(name, klass)
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
      clear
      @injector = Bogus::Injector.new
    end

    def create_stub(*args)
      inject.create_stub(*args)
    end

    def create_mock(*args)
      inject.create_mock(*args)
    end

    def have_received(*args)
      inject.have_received_matcher(*args).method_call
    end

    def fake_for(*args, &block)
      inject.creates_fakes_with_stubbed_methods.create(*args, &block)
    end

    def fake_class(*args)
      inject.fakes_classes.fake(*args)
    end

    def after_each_test
      ensure_all_expectations_satisfied!
    ensure
      clear
    end

    def clear
      reset_stubbed_methods
      clear_expectations
      reset_overwritten_classes
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

    def reset_overwritten_classes
      inject.resets_overwritten_classes.reset
    end

    def fakes(&block)
      inject.fake_configuration.evaluate(&block)
    end

    def inject
      @injector ||= Bogus::Injector.new
    end
  end
end
