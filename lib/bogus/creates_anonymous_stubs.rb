module Bogus
  class CreatesAnonymousStubs
    extend Bogus::Takes

    takes :multi_stubber, :creates_fakes, :responds_to_everything

    def create(name = nil, methods = {}, &block)
      if name.is_a?(Hash)
        methods = name
        name = nil
      end

      fake = responds_to_everything unless name

      fake_opts, methods = split_methods(methods)
      fake ||= creates_fakes.create(name, fake_opts, &block)

      multi_stubber.stub_all(fake, methods)
    end

    private

    def split_methods(methods)
      fake_args = proc{ |k,_| [:as].include?(k) }
      [methods.select(&fake_args), methods.reject(&fake_args)]
    end
  end
end
