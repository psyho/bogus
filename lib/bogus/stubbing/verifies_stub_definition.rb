module Bogus
  class VerifiesStubDefinition
    extend Takes

    takes :method_stringifier

    def verify!(object, method_name, args)
      stubbing_non_existent_method!(object, method_name) unless object.respond_to?(method_name)
      method = object.method(method_name) rescue nil
      return unless method
      return if WithArguments.with_matcher?(args)
      verify_call!(method, args)
    end

    private

    def verify_call!(method, args)
      object = Object.new
      fake_method = method_stringifier.stringify(method, "")
      object.instance_eval(fake_method)
      object.send(method.name, *args)
    rescue ArgumentError
      wrong_arguments!(method, args)
    end

    def wrong_arguments!(method, args)
      args_string = method_stringifier.arguments_as_string(method.parameters)
      raise ArgumentError, "tried to stub #{method.name}(#{args_string}) with arguments: #{args.map(&:inspect).join(",")}"
    end

    def stubbing_non_existent_method!(object, method_name)
      raise NameError, "#{object.inspect} does not respond to #{method_name}"
    end
  end
end
