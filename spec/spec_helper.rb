require 'simplecov'
begin
  require "coveralls"
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter]
rescue LoadError
  warn "warning: coveralls gem not found; skipping Coveralls"
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
end

SimpleCov.start do
  add_filter "/spec/"
end

require 'bogus'
require 'dependor/rspec'

require 'rr'

require_relative 'support/sample_fake'
require_relative 'support/fake_creator_of_fakes'
require_relative 'support/matchers'
require_relative 'support/shared_examples_for_keyword_arguments'

RSpec.configure do |config|
  if config.respond_to? :color=
    # RSpec 3
    config.color = true
  end
  if config.respond_to? :color_enabled=
    # RSpec 2
    config.color_enabled = true
  end
  config.mock_framework = :rr
end

# this should not be necessary...
def have_received(method = nil)
  RR::Adapters::Rspec::InvocationMatcher.new(method)
end
