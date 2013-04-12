module Bogus
  class CopiesClasses
    extend Takes

    takes :copies_methods

    def copy(klass)
      copy_class = Class.new(Bogus::Fake)
      copy_class.__copied_class__ = klass
      copies_methods.copy(klass, copy_class)
      copy_class
    end
  end
end
