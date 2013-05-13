class Bogus::VerifiesStubDefinition
  extend Bogus::Takes

  takes :method_stringifier

  def verify!(object, method_name, args)
    stubbing_non_existent_method!(object, method_name) unless object.respond_to?(method_name)
    return unless object.methods.include?(method_name)
    return if any_args?(args)
    method = object.method(method_name)
    wrong_number_of_arguments!(method, args) if under_number_of_required_arguments?(method, args.size)
    wrong_number_of_arguments!(method, args) if over_number_of_allowed_arguments?(method, args.size)
  end

  private

  def wrong_number_of_arguments!(method, args)
    args_string = method_stringifier.arguments_as_string(method.parameters)
    raise ArgumentError, "tried to stub #{method.name}(#{args_string}) with #{args.size} arguments"
  end

  def stubbing_non_existent_method!(object, method_name)
    raise NameError, "#{object.inspect} does not respond to #{method_name}"
  end

  def under_number_of_required_arguments?(method, args_count)
    number_of_arguments = method.arity
    number_of_arguments = -number_of_arguments - 1 if number_of_arguments < 0

    args_count < number_of_arguments
  end

  def over_number_of_allowed_arguments?(method, args_count)
    return false if method.parameters.find{|type, name| type == :rest}
    number_of_arguments = method.parameters.count{|type, name| [:key, :opt, :req].include?(type) }

    args_count > number_of_arguments
  end

  def any_args?(args)
    [Bogus::AnyArgs] == args
  end
end
