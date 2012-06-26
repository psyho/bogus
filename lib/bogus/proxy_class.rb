class Bogus::ProxyClass
  def initialize(fake_name, klass, create_recording_proxy)
    @fake_name = fake_name
    @klass = klass
    @create_recording_proxy = create_recording_proxy

    @recording_proxy = @create_recording_proxy.call(@klass, @fake_name)
  end

  def new(*args, &block)
    instance = @klass.new(*args, &block)
    @create_recording_proxy.call(instance, @fake_name)
  end

  def method_missing(name, *args, &block)
    @recording_proxy.__send__(name, *args, &block)
  end

  def respond_to?(name)
    @recording_proxy.respond_to?(name)
  end
end
