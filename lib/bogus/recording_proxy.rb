class Bogus::RecordingProxy < BasicObject
  extend ::Bogus::Takes
  takes :instance, :fake_name, :interactions_repository

  def method_missing(name, *args, &block)
    returned_value = @instance.__send__(name, *args, &block)
    @interactions_repository.record(@fake_name, name, *args) { returned_value }
    returned_value
  rescue ::StandardError => e
    @interactions_repository.record(@fake_name, name, *args) { ::Kernel.raise(e) }
    ::Kernel.raise
  end

  # apparently even BasicObject has an equality operator
  def ==(other)
    method_missing(:==, other)
  end

  def respond_to?(name)
    @instance.respond_to?(name)
  end
end

