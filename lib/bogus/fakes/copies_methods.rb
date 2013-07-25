module Bogus
  class CopiesMethods
    extend Takes

    takes :makes_substitute_methods,
      :method_copiers,
      :copies_constructor

    def copy(from, into)
      method_copiers.each do |copier|
        copy_methods(from, into, copier)
      end
      copies_constructor.copy(from, into)
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
