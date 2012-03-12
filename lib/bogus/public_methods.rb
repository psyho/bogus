module Bogus
  module PublicMethods
    def fake_for(name)
      klass = inject.converts_name_to_class.convert(name)
      return inject.creates_fakes.create(klass)
    end

    private

    def inject
      @injector ||= Bogus::Injector.new
    end
  end
end
