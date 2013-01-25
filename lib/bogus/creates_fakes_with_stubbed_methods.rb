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

      fake_opts, methods = split_methods(methods)
      fake_definition = get_configuration(name, fake_opts, methods, block)

      fake ||= creates_fakes.create(fake_definition.name, fake_definition.opts,
                                    &fake_definition.class_block)

      multi_stubber.stub_all(fake, fake_definition.stubs)
    end

    private

    def split_methods(methods)
      fake_args = proc{ |k,_| [:as].include?(k) }
      [methods.select(&fake_args), methods.reject(&fake_args)]
    end

    def get_configuration(name, fake_opts, methods, block)
      fake = FakeDefinition.new(name: name, opts: fake_opts, stubs: methods, class_block: block)
      return fake unless fake_configuration.include?(name)

      configured_fake = fake_configuration.get(name)
      configured_fake.merge(fake)
    end
  end
end
