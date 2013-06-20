module Bogus
  class Arguments
    include Enumerable

    def initialize(args)
      @args = args
    end

    def each(&block)
      args.each(&block)
    end

    def any_args?
      [AnyArgs] == args
    end

    def ==(other)
      return true if any_args? || other.any_args?

      return false unless without_keyword.zip(other).all? {|a1, a2| a1 == a2 || a2 == a1 }

      if has_keyword?
        keyword == other.keyword
      else
        count == other.count
      end
    end

    def keyword
      return {} unless args.last.is_a?(Hash)
      args.last.reject { |_, val| val.eql?(DefaultValue) }
    end

    private

    def args
      @args.reject { |arg| arg.eql?(DefaultValue) }
    end

    def has_keyword?
      return false unless args.last.is_a?(Hash)
      args.last.any? { |_, v| v.eql?(DefaultValue) }
    end

    def without_keyword
      return args unless has_keyword?
      args[0..-2]
    end
  end

  class Interaction < Struct.new(:method, :args, :return_value, :error, :has_result)
    attr_accessor :arguments

    def initialize(method, args, &block)
      self.method = method
      self.args = Arguments.new(args)

      if block_given?
        evaluate_return_value(block)
        self.has_result = true
      end
    end

    def ==(other)
      method == other.method && args == other.args && same_result?(other)
    end

    def any_args?
      args.any_args?
    end

    private

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
