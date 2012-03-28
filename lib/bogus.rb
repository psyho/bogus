require 'dependor'

module Bogus
  autoload :Configuration,        'bogus/configuration'
  autoload :ConvertsNameToClass,  'bogus/converts_name_to_class'
  autoload :CopiesClasses,        'bogus/copies_classes'
  autoload :CreatesFakes,         'bogus/creates_fakes'
  autoload :Injector,             'bogus/injector'
  autoload :MethodStringifier,    'bogus/method_stringifier'
  autoload :PublicMethods,        'bogus/public_methods'
  autoload :RSpecExtensions,      'bogus/rspec_extensions'
  autoload :Takes,                'bogus/takes'
  autoload :VERSION,              'bogus/version'

  extend PublicMethods
end
