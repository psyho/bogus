module Bogus
  class ConvertsNameToClass
    extend Takes

    class CanNotFindClass < RuntimeError; end

    takes :search_modules

    def convert(name)
      class_name = camelize(name)
      klass = nil

      @search_modules.each do |mod|
        klass = mod.const_get(class_name) rescue nil
        break if klass
      end

      raise CanNotFindClass.new("Can not locate class for name: #{name}") unless klass

      klass
    end

    private

    def camelize(symbol)
      string = symbol.to_s
      string = string.gsub(/_\w/) { |match| match[1].upcase }
      return string.gsub(/^\w/) { |match| match.upcase }
    end
  end
end
