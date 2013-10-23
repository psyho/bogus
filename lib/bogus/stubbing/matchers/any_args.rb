require_relative 'with_arguments'

module Bogus
  AnyArgs = WithArguments.new{ true }

  def AnyArgs.inspect
    "any_args"
  end
end
