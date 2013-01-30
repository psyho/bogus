module Bogus
  module RSpecAdapter
    def setup_mocks_for_rspec
      # no setup needed
    end

    def verify_mocks_for_rspec
      Bogus.ensure_all_expectations_satisfied!
    end

    def teardown_mocks_for_rspec
      Bogus.reset_stubbed_methods
      Bogus.clear_expectations
    end
  end
end
