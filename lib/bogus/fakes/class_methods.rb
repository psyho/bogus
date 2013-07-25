module Bogus
  class ClassMethods
    extend Takes
    takes :klass

    def all
      klass.methods - Class.methods - bogus_methods
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

    private

    def bogus_methods
      [:__shadow__, :__reset__, :__overwrite__, :__overwritten_methods__, :__record__]
    end
  end
end
