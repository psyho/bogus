RSpec.configure do |config|
  config.extend Bogus::RSpecExtensions
  config.include Bogus::MockingDSL
end
