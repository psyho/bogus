module Bogus
  class CopiesClasses
    extend Takes

    takes :copies_methods

    def copy(klass)
      copy_class = Class.new(Bogus::Fake) do
        define_singleton_method(:__copied_class__) do
          klass
        end
      end
      copies_methods.copy(klass, copy_class)
      copy_class
    end
  end
end
