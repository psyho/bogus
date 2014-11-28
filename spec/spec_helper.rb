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

require_relative 'support/sample_fake'
require_relative 'support/fake_creator_of_fakes'
require_relative 'support/matchers'
require_relative 'support/shared_examples_for_keyword_arguments'
require_relative 'support/ruby_features'

RSpec.configure do |config|
  config.mock_with :rspec
end
