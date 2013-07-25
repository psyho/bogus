module Bogus
  class BaseClassIdentifier
    extend Takes
    takes :copied_class, :klass

    def self.base_class?(copied_class, klass)
      new(copied_class, klass).base_class?
    end

    def base_class?
      same? || included_module? || subclass?
    end

    private

    def same?
      klass == copied_class
    end

    def included_module?
      copied_class.included_modules.include?(klass)
    end

    def subclass?
      superclasses.include?(klass)
    end

    def superclasses
      return [] unless copied_class.is_a?(Class)
      klass = copied_class
      superclasses = []
      while klass
        superclasses << klass
        klass = klass.superclass
      end
      superclasses
    end
  end
end
