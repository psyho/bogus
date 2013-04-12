module Bogus
  class CopiesMethods
    extend Bogus::Takes

    takes :makes_substitute_methods,
      :instance_methods,
      :class_methods

    def copy(from, into)
      copy_methods(from, into, instance_methods)
      copy_methods(from, into, class_methods)
    end

    private

    def copy_methods(original_class, copy_class, make_methods)
      original_methods = make_methods.call(original_class)
      copy_methods = make_methods.call(copy_class)

      original_methods.all.each do |name|
        method = original_methods.get(name)
        body = method_as_string(method)
        copy_methods.define(body)
      end
    end

    def method_as_string(method)
      makes_substitute_methods.stringify(method)
    end
  end
end
