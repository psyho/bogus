module Bogus
  class MakesSubstituteMethods
    extend Takes

    takes :method_stringifier

    def stringify(method)
      args = method_stringifier.argument_values(method.parameters)

      send_args = [method.name.inspect, args].reject(&:empty?).join(', ')

      method_stringifier.stringify(method, "__record__(#{send_args})")
    end
  end
end
