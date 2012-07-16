class Bogus::Interaction < Struct.new(:method, :args, :return_value, :has_return_value)
  def initialize(method, args, &block)
    self.method = method
    self.args = args

    if block_given?
      self.return_value = block.call
      self.has_return_value = true
    end
  end

  def ==(other)
    return super(other) if has_return_value && other.has_return_value
    method == other.method && args == other.args
  end
end
