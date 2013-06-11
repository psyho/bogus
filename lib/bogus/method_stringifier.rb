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
      stringify_arguments(arguments, DefaultValue)
    end

    def argument_values(arguments)
      stringify_arguments(arguments)
    end

    private

    def stringify_arguments(arguments, default = nil)
      fill_in_missing_names(arguments).map do |type, name|
        argument_to_string(name, type, default)
      end.join(', ')
    end

    def argument_to_string(name, type, default)
      case type
      when :block then "&#{name}"
      when :key then default ? "#{name}: #{default}" : "#{name}: #{name}"
      when :opt then default ? "#{name} = #{default}" : name
      when :req then name
      when :rest then "*#{name}"
      when :keyrest then "**#{name}"
      else raise "unknown argument type: #{type}"
      end
    end

    def fill_in_missing_names(arguments)
      noname_count = 0
      arguments.map do |type, name|
        unless name
          name = "_noname_#{noname_count}"
          noname_count += 1
        end
        [type, name]
      end
    end

  end
end
