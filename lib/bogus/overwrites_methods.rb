module Bogus
  class OverwritesMethods
    extend Takes

    takes :makes_substitute_methods

    def overwrite(object, name)
      raise "wut?" if name == :__shadow__
      return if object.is_a?(FakeObject)

      object.extend RecordInteractions
      object.extend HasOverwritenMethods

      method = method_by_name(object, name)
      copy = copy(object, name)

      object.__overwrite__(name, method, copy)
    end

    def reset(object)
      return if object.is_a?(FakeObject)

      object.__reset__
    end

    private

    def method_by_name(object, name)
      object.method(name) if object.methods.include?(name)
    end

    def copy(object, name)
      method = method_by_name(object, name)
      return default_method(name) unless method
      makes_substitute_methods.stringify(method)
    end

    def default_method(name)
      "def #{name}(*args, &block); __record__(:#{name}, *args, &block); end"
    end
  end
end
