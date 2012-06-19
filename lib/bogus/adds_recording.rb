class Bogus::AddsRecording
  extend Bogus::Takes

  takes :converts_name_to_class, :create_proxy_class, :overwrites_classes

  def add(name)
    klass = converts_name_to_class.convert(name)
    new_klass = create_proxy_class.call(name, klass)
    overwrites_classes.overwrite(klass, new_klass)
  end
end
