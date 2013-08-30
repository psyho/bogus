module Bogus
  class CachesCopiedClasses
    extend Takes

    takes :copies_classes

    def copy(klass)
      cache[klass] ||= copies_classes.copy(klass)
    end

    private

    def cache
      @cache ||= {}
    end
  end
end
