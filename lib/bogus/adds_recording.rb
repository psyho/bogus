module Bogus
  class AddsRecording
    extend Takes

    takes :create_proxy_class, :overwrites_classes,
      :overwritten_classes

    def add(name, klass)
      new_klass = create_proxy_class.call(name, klass)
      overwrites_classes.overwrite(klass.name, new_klass)
      overwritten_classes.add(klass.name, klass)
      new_klass
    end
  end
end
