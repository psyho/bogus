require 'bogus'

RSpec.configure do |config|
  config.extend Bogus::RSpecExtensions
  config.include Bogus::MockingDSL

  config.mock_with Bogus::RSpecAdapter

  if RSpec::Core::Version::STRING >= "2.14"
    config.backtrace_exclusion_patterns << Regexp.new("lib/bogus")
  else
    config.backtrace_clean_patterns << Regexp.new("lib/bogus")
  end

  config.after(:suite) do
    Bogus.reset!
  end
end
