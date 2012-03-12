Then /^all the specs should pass$/ do
  steps %Q{
    Then the output should contain "0 failures"
    And the exit status should be 0
  }
end
