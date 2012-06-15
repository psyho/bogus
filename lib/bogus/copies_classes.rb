module Bogus
  class CopiesClasses
    extend Takes

    takes :method_stringifier

    def copy(klass)
      copy_class = Class.new(Bogus::Fake)

      copy_class.__copied_class__ = klass
      copy_instance_methods(klass, copy_class)
      copy_class_methods(klass, copy_class)

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

    def method_as_string(method)
      args = @method_stringifier.arguments_as_string(method.parameters)
      args_no_defaults = args.gsub(' = {}', '')

      @method_stringifier.stringify(method,
        "__record__(:#{method.name}, #{args_no_defaults})")
    end

  end
end
