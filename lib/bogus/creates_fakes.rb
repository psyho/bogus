module Bogus
  class CreatesFakes
    class UnknownMode < RuntimeError; end

    extend Takes

    takes :copies_classes, :converts_name_to_class

    def create(name, opts = {})
      klass = converts_name_to_class.convert(name)
      klass_copy = copies_classes.copy(klass)

      mode = opts.fetch(:as, :instance)

      case mode
      when :instance
        return klass_copy.new
      when :class
        return klass_copy
      else
        raise UnknownMode.new("Unknown fake creation mode: #{mode}. Allowed values are :instance, :class")
      end
    end
  end
end
