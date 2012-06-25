Given /^a spec file named "([^"]*)" with:$/ do |file_name, string|
  @spec_file_names ||= []
  @spec_file_names << file_name

  steps %Q{
    Given a file named "#{file_name}" with:
    """ruby
    require 'bogus'
    require 'bogus/rspec'
    require 'rr'

    require_relative 'foo'

    RSpec.configure do |config|
      config.mock_with :rr
    end

    #{string}
    """
  }
end

Then /^the specs should fail$/ do
  steps %Q{
    Then the exit status should not be 0
  }
end

Then /^all the specs should pass$/ do
  steps %Q{
    Then the exit status should be 0
  }
end

When /^I run spec with the following content:$/ do |string|
  file_name = 'foo_spec.rb'

  steps %Q{
    Given a spec file named "#{file_name}" with:
    """ruby
    #{string}
    """
  }

  steps %Q{
    When I run `rspec #{@spec_file_names.join(' ')}`
  }
end

Then /^spec file with following content should pass:$/ do |string|
  steps %Q{
    When I run spec with the following content:
    """ruby
    #{string}
    """
    Then all the specs should pass
  }
end

Then /^spec file with following content should fail:$/ do |string|
  steps %Q{
    When I run spec with the following content:
    """ruby
    #{string}
    """
    Then the specs should fail
  }
end
