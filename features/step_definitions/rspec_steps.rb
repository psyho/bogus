Then /^all the specs should pass$/ do
  steps %Q{
    Then the output should contain "0 failures"
    And the exit status should be 0
  }
end

Then /^spec file with following content should pass:$/ do |string|
  file_name = 'foo_spec.rb'

  steps %Q{
    Given a file named "#{file_name}" with:
    """ruby
    require 'bogus'
    require 'bogus/rspec'

    require_relative 'foo'

    #{string}
    """
    When I run `rspec #{file_name}`
    Then all the specs should pass
  }
end
