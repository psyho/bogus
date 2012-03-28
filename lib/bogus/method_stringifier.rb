module Bogus
  class MethodStringifier

    def stringify(method, body)
      <<-RUBY
      def #{method.name}(#{arguments_as_string(method.parameters)})
        #{body}
      end
      RUBY
    end

    def arguments_as_string(arguments)
      arguments.map{|type, name| argument_to_string(name, type) }.compact.join(', ')
    end

    def argument_to_string(name, type)
      if type == :req
        name
      elsif type == :rest
        "*#{name}"
      elsif type == :block
        "&#{name}"
      elsif type == :opt
        "#{name} = {}"
      else
        raise "unknown argument type: #{type}"
      end
    end

  end
end
