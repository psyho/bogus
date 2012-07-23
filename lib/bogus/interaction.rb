class Bogus::Interaction < Struct.new(:method, :args, :return_value, :error, :has_result)
  def initialize(method, args, &block)
    self.method = method
    self.args = args

    if block_given?
      evaluate_return_value(block)
      self.has_result = true
    end
  end

  def ==(other)
    return super(other) if has_result && other.has_result
    method == other.method && args == other.args
  end

  private

  def evaluate_return_value(block)
    self.return_value = block.call
  rescue => e
    self.error = e.class
  end
end
