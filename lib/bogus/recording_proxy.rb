class Bogus::RecordingProxy < BasicObject
  def initialize(instance, fake_name, interactions_repository)
    @instance = instance
    @fake_name = fake_name
    @interactions_repository = interactions_repository
  end

  def method_missing(name, *args, &block)
    returned_value = @instance.__send__(name, *args, &block)
    @interactions_repository.record(@fake_name, name, *args) { returned_value }
    returned_value
  rescue => e
    @interactions_repository.record(@fake_name, name, *args) { ::Kernel.raise(e) }
    ::Kernel.raise
  end

  def respond_to?(name)
    @instance.respond_to?(name)
  end
end

