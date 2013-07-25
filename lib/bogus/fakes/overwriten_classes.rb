module Bogus
  class OverwrittenClasses
    def add(name, klass)
      classes << [name, klass]
    end

    def clear
      @classes = []
    end

    def classes
      @classes ||= []
    end
  end
end
