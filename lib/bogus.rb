module Bogus
  autoload :VERSION, 'bogus/version'
  autoload :Injector, 'bogus/injector'

  autoload :RSpecExtensions, 'bogus/rspec_extensions'
  autoload :PublicMethods, 'bogus/public_methods'

  extend PublicMethods
end
