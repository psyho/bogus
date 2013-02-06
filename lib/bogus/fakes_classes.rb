module Bogus
  class FakesClasses
    extend Takes

    takes :creates_fakes_with_stubbed_methods, :overwrites_classes, :overwritten_classes

    def fake(klass, opts = {})
      opts = opts.merge(as: :class)
      name = opts.delete(:fake_name) || underscore(klass.name.split('::').last).to_sym
      fake = creates_fakes_with_stubbed_methods.create(name, opts) { klass }
      overwrites_classes.overwrite(klass.name, fake)
      overwritten_classes.add(klass.name, klass)
    end

    private

    def underscore(str)
      str.gsub(/[A-Z]/) { |s| "_" + s.downcase }.gsub(/^_/, '')
    end
  end
end
