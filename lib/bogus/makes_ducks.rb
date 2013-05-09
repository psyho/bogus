module Bogus
  class MakesDucks
    extend Bogus::Takes

    takes :class_methods, :instance_methods, :makes_subtypes

    def make(first_class, *classes)
      duck = makes_subtypes.make(first_class)
      classes.each do |klass|
        remove_methods(class_methods.call(duck),
                       class_methods.call(klass))
        remove_methods(instance_methods.call(duck),
                       instance_methods.call(klass))
      end
      duck
    end

    private

    def remove_methods(duck_methods, klass_methods)
      not_in_klass = duck_methods.all - klass_methods.all
      not_in_klass.each { |name| duck_methods.remove(name) }

      duck_methods.all.each do |name|
        duck_method = duck_methods.get(name)
        klass_method = klass_methods.get(name)
        unless same_interface?(duck_method, klass_method)
          duck_methods.remove(name)
        end
      end
    end

    def same_interface?(method1, method2)
      method1.parameters == method2.parameters
    end
  end
end
