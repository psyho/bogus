require 'aruba/cucumber'
require 'aruba/jruby'

Before('@known_bug') do
  pending("This scenario fails because of a known bug")
end

Before do |scenario|
  dir_name = "scenario-#{rand(1_000_000)}"
  create_dir(dir_name)
  cd(dir_name)
end

Before do
  @aruba_timeout_seconds = 60
end
