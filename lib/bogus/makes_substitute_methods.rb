module Bogus
  class MakesSubstituteMethods
    extend Takes

    takes :method_stringifier

    def stringify(method)
      args = method_stringifier.argument_values(method.parameters)

      method_stringifier.stringify(method,
        "__record__(:#{method.name}, #{args})")
    end
  end
end
