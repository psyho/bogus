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
      arguments = fill_in_missing_names(arguments)
      arguments.map{|type, name| argument_to_string(name, type) }.compact.join(', ')
    end

    def argument_to_string(name, type)
      case type
      when :block then "&#{name}"
      when :key   then "#{name}: Bogus::Anything"
      when :opt   then "#{name} = {}"
      when :req   then name
      when :rest  then "*#{name}"
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
