module Bogus
  class HaveReceivedMatcher
    include ProxiesMethodCalls

    extend Takes
    NO_SHADOW = "Given object is not a fake and nothing was ever stubbed or mocked on it!"

    takes :verifies_stub_definition, :records_double_interactions

    def matches?(subject)
      @subject = subject
      return false unless Shadow.has_shadow?(subject)

      verifies_stub_definition.verify!(subject, @name, @args)
      records_double_interactions.record(subject, @name, @args)

      subject.__shadow__.has_received(@name, @args)
    end

    def description
      "have received #{call_str(@name, @args)}"
    end

    def failure_message_for_should
      return NO_SHADOW unless Shadow.has_shadow?(@subject)
      %Q{Expected #{@subject.inspect} to #{description}, but it didn't.\n\n} + all_calls_str
    end

    def failure_message_for_should_not
      return NO_SHADOW unless Shadow.has_shadow?(@subject)
      %Q{Expected #{@subject.inspect} not to #{description}, but it did.}
    end

    def method_call
      proxy(:set_method)
    end

    def build(*args)
      return method_call if args.empty?
      set_method(*args)
    end

    def set_method(name, *args, &block)
      @name = name
      @args = args
      self
    end

    private

    def call_str(method, args)
      "#{method}(#{args.map(&:inspect).join(', ')})"
    end

    def all_calls_str
      shadow = @subject.__shadow__
      calls = shadow.calls.map{|i| call_str(i.method, i.args)}

      if calls.any?
        message = "The recorded interactions were:\n"
        calls.each{|s| message << "  - #{s}\n"}
        message
      else
        "There were no interactions with this object.\n"
      end
    end
  end
end
