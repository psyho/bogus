gem 'minitest', '>= 4.7'
require 'bogus'

module MiniTest::Assertions
  def assert_received(subject, method, args, message = nil)
    with_bogus_matcher_for(subject, method, args) do |matcher, result|
      assert(result, message || matcher.failure_message_for_should)
    end
  end

  def refute_received(subject, method, args, message = nil)
    with_bogus_matcher_for(subject, method, args) do |matcher, result|
      refute(result, message || matcher.failure_message_for_should_not)
    end
  end

  private

  def with_bogus_matcher_for(subject, method, args)
    matcher = Bogus.have_received.__send__(method, *args)
    result  = matcher.matches?(subject)
    yield matcher, result
  end
end

module Bogus::Minitest
  include Bogus::MockingDSL

  def before_setup
    super
    Bogus.clear
  end

  def after_teardown
    Bogus.ensure_all_expectations_satisfied!
    super
  end
end

# minitest 5 vs 4.7
if defined? ::Minitest::Test
  class ::Minitest::Test
    include Bogus::Minitest
  end
else
  class MiniTest::Unit::TestCase
    include Bogus::Minitest
  end
end
