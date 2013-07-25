module Bogus
  class SameClass
    extend Takes
    takes :klass

    def inspect
      "any(#{klass.name})"
    end

    def ==(other)
      other.is_a?(klass)
    end
  end
end
