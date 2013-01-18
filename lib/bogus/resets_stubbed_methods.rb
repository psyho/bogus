module Bogus
  class ResetsStubbedMethods
    extend Takes

    takes :double_tracker, :overwrites_methods

    def reset_all_doubles
      doubles = double_tracker.doubles
      doubles.each { |double| overwrites_methods.reset(double) }
    end
  end
end
