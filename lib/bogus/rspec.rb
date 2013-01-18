require 'bogus'

RSpec.configure do |config|
  config.extend Bogus::RSpecExtensions
  config.include Bogus::MockingDSL

  config.after(:each) do
    Bogus.after_each_test
  end
end
