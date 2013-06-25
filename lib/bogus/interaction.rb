module Bogus
  class Interaction < Struct.new(:method, :args, :return_value, :error, :has_result)
    attr_accessor :arguments

    def self.same?(opts = {})
      InteractionComparator.new(opts).same?
    end

    def initialize(method, args, &block)
      self.method = method
      self.args = args

      if block_given?
        evaluate_return_value(block)
        self.has_result = true
      end
    end

    private

    def evaluate_return_value(block)
      self.return_value = block.call
    rescue => e
      self.error = e.class
    end

    class InteractionComparator
      attr_reader :recorded, :stubbed

      def initialize(opts = {})
        @recorded = opts.fetch(:recorded)
        @stubbed = opts.fetch(:stubbed)
      end

      def same?
        return false unless recorded.method == stubbed.method
        return false unless same_result?
        same_args?
      end

      private

      def same_args?
        ArgumentComparator.new(recorded: recorded.args, stubbed: stubbed.args).same?
      end

      def same_result?
        return true unless recorded.has_result && stubbed.has_result
        recorded.return_value == stubbed.return_value && recorded.error == stubbed.error
      end
    end

    class ArgumentComparator
      attr_reader :recorded, :stubbed

      def initialize(opts = {})
        @recorded = opts.fetch(:recorded)
        @stubbed = opts.fetch(:stubbed)
      end

      def same?
        return true if any_args?

        stubbed == recorded_without_defaults
      end

      private

      def recorded_without_defaults
        without_defaults = recorded.reject{|v| DefaultValue == v}
        remove_default_keywords(without_defaults)
      end

      def remove_default_keywords(recorded)
        return recorded unless recorded_has_keyword?
        positional = recorded[0...-1]
        keyword = recorded.last
        without_defaults = keyword.reject{|_, v| DefaultValue == v}
        return positional if without_defaults.empty?
        positional + [without_defaults]
      end

      def any_args?
        AnyArgs.any_args?(stubbed)
      end

      def recorded_has_keyword?
        last_recorded = recorded.last
        return false unless last_recorded.is_a?(Hash)
        last_recorded.values.any? { |v| DefaultValue == v }
      end
    end
  end
end
