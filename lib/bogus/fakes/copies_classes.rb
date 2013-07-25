module Bogus
  class CopiesClasses
    extend Takes

    takes :copies_methods

    def copy(klass)
      copy_class = Class.new(Bogus::Fake) do
        define_singleton_method(:__copied_class__) do
          klass
        end

        define_singleton_method(:name) do
          klass.name
        end

        define_singleton_method(:to_s) do
          klass.name
        end

        define_singleton_method(:const_missing) do |name|
          klass.const_get(name)
        end
      end

      copies_methods.copy(klass, copy_class)
      copy_class
    end
  end
end
