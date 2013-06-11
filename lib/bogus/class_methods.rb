module Bogus
  class ClassMethods
    extend Takes
    takes :klass

    def all
      klass.methods - Class.methods
    end

    def get(name)
      klass.method(name)
    end

    def remove(name)
      klass.instance_eval "undef #{name}"
    end

    def define(body)
      klass.instance_eval(body)
    end
  end
end
