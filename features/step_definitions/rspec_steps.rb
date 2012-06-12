Then /^the specs should fail$/ do
  steps %Q{
    Then the output should not contain "0 failures"
    And the exit status should not be 0
  }
end

Then /^all the specs should pass$/ do
  steps %Q{
    Then the output should contain "0 failures"
    And the exit status should be 0
  }
end

When /^I run spec with the following content:$/ do |string|
  file_name = 'foo_spec.rb'

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
    When I run `rspec #{file_name}`
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
