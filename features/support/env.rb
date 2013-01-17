require 'aruba/cucumber'

Before('@known_bug') do
  pending("This scenario fails because of a known bug")
end
