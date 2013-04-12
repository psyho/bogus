module Bogus
  class MakesSubtypes
    extend Bogus::Takes

    takes :copies_methods

    def make(klass)
      subtype = klass.is_a?(Class) ? Class.new : Module.new
      copies_methods.copy(klass, subtype)
      subtype
    end
  end
end
