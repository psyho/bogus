module Bogus
  class CopiesClasses
    extend Takes

    takes :method_stringifier

    def copy(klass)
      copy_class = Class.new

      copy_instance_methods(klass, copy_class)
      copy_class_methods(klass, copy_class)
      add_constructor(copy_class)
      override_kind_and_instance_of(klass, copy_class)
      override_class_name(klass, copy_class)

      return copy_class
    end

    private

    def copy_instance_methods(klass, copy_class)
      instance_methods = klass.instance_methods - Object.instance_methods

      instance_methods.each do |name|
        copy_class.class_eval(method_as_string(klass.instance_method(name)))
      end
    end

    def copy_class_methods(klass, copy_class)
      klass_methods = klass.methods - Class.methods

      klass_methods.each do |name|
        copy_class.instance_eval(method_as_string(klass.method(name)))
      end
    end

    def add_constructor(copy_class)
      copy_class.class_eval do
        def initialize(*args)
        end
      end
    end

    def override_kind_and_instance_of(klass, copy_class)
      copy_class.instance_eval do
        [:kind_of?, :instance_of?].each do |method|
          define_method method do |other_klass|
            return true if klass == other_klass
          end
        end
      end
    end

    def override_class_name(klass, copy_class)
      copy_class.instance_eval <<-RUBY
        def name
          "#{klass.name}"
        end
      RUBY
    end

    def method_as_string(method)
      @method_stringifier.stringify(method, "self")
    end

  end
end
