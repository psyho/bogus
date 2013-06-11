module Bogus
  class InstanceMethods
    extend Takes
    takes :klass

    def all
      klass.instance_methods - Object.instance_methods
    end

    def get(name)
      klass.instance_method(name)
    end

    def remove(name)
      klass.send(:undef_method, name)
    end

    def define(body)
      klass.class_eval(body)
    end
  end
end
