require 'bogus'

RSpec.configure do |config|
  config.extend Bogus::RSpecExtensions
  config.include Bogus::MockingDSL

  config.mock_with Bogus::RSpecAdapter
  config.backtrace_exclusion_patterns << Regexp.new("lib/bogus")

  config.after(:suite) do
    Bogus.reset!
  end
end
