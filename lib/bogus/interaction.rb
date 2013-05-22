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

    private

    def same_args?(other)
      return true if any_args? || other.any_args?
      return false unless args.size == other.args.size
      args.zip(other.args).all?{|a1, a2| a1 == a2 || a2 == a1}
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
  end
end
