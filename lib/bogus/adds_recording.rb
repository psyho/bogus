module Bogus
  class AddsRecording
    extend Takes

    takes :converts_name_to_class, :create_proxy_class, :overwrites_classes,
      :overwritten_classes

    def add(name, klass = nil)
      klass ||= converts_name_to_class.convert(name)
      new_klass = create_proxy_class.call(name, klass)
      overwrites_classes.overwrite(klass.name, new_klass)
      overwritten_classes.add(klass.name, klass)
    end
  end
end
