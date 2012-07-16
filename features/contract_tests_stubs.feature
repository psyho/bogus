Feature: Contract tests with stubs

  Background:
    Given a file named "foo.rb" with:
    """ruby
      class Timer
        def current_time
          Time.new("2011/01/01")
        end
      end

      class Pomodoro
        def initialize(timer)
          @timer = timer
        end

        def time_for_break?
          @timer.current_time == Time.new("2012/02/02")
        end
      end
    """
    And a spec file named "pomodoro_spec.rb" with:
    """ruby
    describe Pomodoro do
      fake(:timer)

      it "determines whether it is time for a break" do
        stub(timer).current_time { Time.new("2012/02/02") }
        pomodoro = Pomodoro.new(timer)

        pomodoro.should be_time_for_break
      end
    end
    """

  Scenario: Fails when stubbed methods are not called on real object
    Then spec file with following content should fail:
    """ruby
    describe Timer do
      verify_contract(:timer)
    end
    """

  Scenario: Verifies that stubbed methods are called
    Then spec file with following content should pass:
    """ruby
    describe Timer do
      verify_contract(:timer)

      it "returns current time" do
        Timer.new.current_time.should == Time.new("2011/01/01")
      end
    end
    """
