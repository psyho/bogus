module Bogus
  class CopiesConstructor
    extend Bogus::Takes
    takes :method_stringifier, :instance_methods, :class_methods

    def copy(from, into)
      return unless from.is_a?(Class)
      initializer = instance_methods.call(from).get(:initialize)
      body = body(initializer)
      class_methods.call(into).define(body)
    end

    def body(initializer)
      body = method_stringifier.stringify(initializer, "super")
      body.gsub("initialize", "new")
    end
  end
end
