module Bogus
  class CreatesFakes
    class UnknownMode < RuntimeError; end

    extend Takes

    takes :copies_classes, :converts_name_to_class, :makes_ducks

    def create(name, opts = {}, &block)
      klass = self.klass(name, &block)
      duck = make_duck(klass)
      klass_copy = copies_classes.copy(duck)

      mode = opts.fetch(:as, :instance)

      case mode
      when :instance
        return klass_copy.__create__
      when :class
        return klass_copy
      else
        raise UnknownMode.new("Unknown fake creation mode: #{mode}. Allowed values are :instance, :class")
      end
    end

    protected

    def klass(name, &block)
      return block.call if block_given?
      converts_name_to_class.convert(name)
    end

    def make_duck(klass)
      return klass unless klass.is_a?(Array)
      makes_ducks.make(*klass)
    end
  end
end
