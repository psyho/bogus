require 'set'

module Bogus
  module HasOverwritenMethods
    def self.aliased_name(name)
      :"__bogus__alias__#{name}"
    end

    def self.alias(object, new_name, name)
      object.singleton_class.send(:alias_method, new_name, name)
    end

    def __overwritten_methods__
      @__overwritten_methods__ ||= Set.new
    end

    def __overwrite__(name, method, body)
      return if __overwritten_methods__.include?(name)

      new_name = HasOverwritenMethods.aliased_name(name)
      HasOverwritenMethods.alias(self, new_name, name) if method

      __overwritten_methods__ << name

      instance_eval(body)
    end

    def __reset__
      __overwritten_methods__.each do |name|
        new_name = HasOverwritenMethods.aliased_name(name)

        if respond_to?(new_name)
          HasOverwritenMethods.alias(self, name, new_name)
          instance_eval "undef #{new_name}"
        else
          instance_eval "undef #{name}"
        end
      end
      @__overwritten_methods__ = nil
      @__shadow__ = nil
    end
  end
end
