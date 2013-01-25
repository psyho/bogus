module Bogus
  class CreatesFakesWithStubbedMethods
    extend Bogus::Takes

    takes :multi_stubber, :creates_fakes,
      :responds_to_everything, :fake_configuration

    def create(name = nil, methods = {}, &block)
      if name.is_a?(Hash)
        methods = name
        name = nil
      end

      fake = responds_to_everything unless name

      methods, block = get_configuration(name, methods, block)

      fake_opts, methods = split_methods(methods)
      fake ||= creates_fakes.create(name, fake_opts, &block)

      multi_stubber.stub_all(fake, methods)
    end

    private

    def split_methods(methods)
      fake_args = proc{ |k,_| [:as].include?(k) }
      [methods.select(&fake_args), methods.reject(&fake_args)]
    end

    def get_configuration(name, methods, block)
      return [methods, block] unless fake_configuration.include?(name)
      conf_methods, conf_block = fake_configuration.get(name)

      [conf_methods.merge(methods), block || conf_block]
    end
  end
end
