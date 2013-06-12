module Bogus
  class Interaction < Struct.new(:method, :args, :return_value, :error, :has_result)
    def initialize(method, args, &block)
      self.method = method
      self.args = args

      if block_given?
        evaluate_return_value(block)
        self.has_result = true
      end
    end

    def ==(other)
      method == other.method && same_args?(other) && same_result?(other)
    end

    def any_args?
      [AnyArgs] == args
    end

    def args
      args = super.map { |arg| remove_default_values_from_hash(arg) }
      args.reject { |arg| arg.eql?(DefaultValue) }
    end

    private

    def same_args?(other)
      return true if any_args? || other.any_args?

      other_args = normalize_other_args(args, other.args)
      return false unless args.size == other_args.size
      args.zip(other_args).all?{|a1, a2| a1 == a2 || a2 == a1}
    end

    def normalize_other_args(args, other_args)
      if args.last.is_a?(Hash) && !other_args.last.is_a?(Hash)
        other_args + [{}]
      else
        other_args
      end
    end

    def same_result?(other)
      return true unless has_result && other.has_result
      return_value == other.return_value && error == other.error
    end

    def evaluate_return_value(block)
      self.return_value = block.call
    rescue => e
      self.error = e.class
    end

    def remove_default_values_from_hash(arg)
      if arg.is_a?(Hash)
        arg.reject { |_, val| val.eql?(DefaultValue) }
      else
        arg
      end
    end
  end
end
