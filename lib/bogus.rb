require 'dependor'

module Bogus
  autoload :Configuration, 'bogus/configuration'
  autoload :ConvertsNameToClass, 'bogus/converts_name_to_class'
  autoload :CreatesFakes, 'bogus/creates_fakes'
  autoload :Injector, 'bogus/injector'
  autoload :PublicMethods, 'bogus/public_methods'
  autoload :RSpecExtensions, 'bogus/rspec_extensions'
  autoload :VERSION, 'bogus/version'

  extend PublicMethods
end
