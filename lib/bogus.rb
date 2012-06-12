require 'dependor'

module Bogus
  autoload :Configuration,             'bogus/configuration'
  autoload :ConvertsNameToClass,       'bogus/converts_name_to_class'
  autoload :CopiesClasses,             'bogus/copies_classes'
  autoload :CreatesFakes,              'bogus/creates_fakes'
  autoload :CreatesStubs,              'bogus/creates_stubs'
  autoload :Injector,                  'bogus/injector'
  autoload :MethodStringifier,         'bogus/method_stringifier'
  autoload :MockingDSL,                'bogus/mocking_dsl'
  autoload :PublicMethods,             'bogus/public_methods'
  autoload :RSpecExtensions,           'bogus/rspec_extensions'
  autoload :Stub,                      'bogus/stub'
  autoload :RRProxy,                   'bogus/rr_proxy'
  autoload :Takes,                     'bogus/takes'
  autoload :VerifiesStubDefinition,    'bogus/verifies_stub_definition'
  autoload :VERSION,                   'bogus/version'

  extend PublicMethods
end
