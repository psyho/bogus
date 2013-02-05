module Bogus
  class ResetsOverwrittenClasses
    extend Takes

    takes :overwritten_classes, :overwrites_classes

    def reset
      overwritten_classes.classes.each do |name, klass|
        overwrites_classes.overwrite(name, klass)
      end
      overwritten_classes.clear
    end
  end
end
