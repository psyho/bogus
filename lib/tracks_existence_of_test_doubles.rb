module Bogus
  class TracksExistenceOfTestDoubles
    def track(object)
      doubles << object unless doubles.include?(object)
    end

    def doubles
      @doubles ||= []
    end
  end
end
