module Bogus
  class GetsShadow
    extend Bogus::Takes

    takes :rr_shadow

    def for(object)
      return object.__shadow__ if has_shadow?(object)
      rr_shadow.call(object)
    end

    private

    def has_shadow?(object)
      object.is_a?(RecordInteractions)
    end
  end
end
