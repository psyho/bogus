module Bogus
  class MakesSubstituteMethods
    extend Takes

    takes :method_stringifier

    def stringify(method)
      args = method_stringifier.arguments_as_string(method.parameters)
      args_no_defaults = args.gsub(' = {}', '')

      method_stringifier.stringify(method,
        "__record__(:#{method.name}, #{args_no_defaults})")
    end
  end
end
