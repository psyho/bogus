require 'bogus'

RSpec.configure do |config|
  config.extend Bogus::RSpecExtensions
  config.include Bogus::MockingDSL

  config.after(:each) do
    Bogus.ensure_all_expectations_satisfied!
    Bogus.clear_expectations
  end
end
