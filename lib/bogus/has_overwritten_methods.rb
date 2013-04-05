module Bogus
  module HasOverwritenMethods
    def __overwritten_methods__
      @__overwritten_methods__ ||= {}
    end

    def __overwrite__(name, method, body)
      return if __overwritten_methods__[name]
      method = method.to_proc if method
      __overwritten_methods__[name] = method || :no_such_method
      instance_eval(body)
    end

    def __reset__
      __overwritten_methods__.each do |name, method|
        method = __overwritten_methods__.delete(name)
        instance_eval "undef #{name}"
        next if method == :no_such_method
        define_singleton_method(name, method)
      end
      @__overwritten_methods__ = {}
      @__shadow__ = nil
    end
  end
end
