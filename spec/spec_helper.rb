require 'bogus'
require 'dependor/rspec'

require 'rr'

require_relative 'support/sample_fake'

RSpec.configure do |config|
  config.color_enabled = true
  config.mock_framework = :rr
end

# this should not be necessary...
def have_received(method = nil)
  RR::Adapters::Rspec::InvocationMatcher.new(method)
end
