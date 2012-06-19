class Bogus::ProxyClass
  extend Bogus::Takes

  takes :fake_name, :klass, :create_recording_proxy

  def new(*args, &block)
    instance = @klass.new(*args, &block)
    create_recording_proxy.call(instance, fake_name)
  end
end
