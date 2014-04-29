## 0.1.5

- Made it possible to use fake objects in case/when statements (override ===)
- Allowed stubbing methods defined on Object, such as #to_json
- Added `matches` - for matching single arguments when stubbing
- Updated RSpec syntax in specs and features (thanks to Michael Durrant)
- Done some housekeeping around development dependencies/Gemfile.lock/TravisCI configuration (thanks to Ken Dreyer)
- Removed deprecation warnings when using Bogus with RSpec 3.0 (thanks to Michal Muskala)
- Added support for Ruby 2.1 required keyword arguments (thanks to Indrek Juhkam)
- Fixed a bug that made it impossible to stub .new on fake classes

## 0.1.4

- Support for contracts in minitest
- Allowed customizing the class being overwritten by verify_contract
- Fixed is_a? behavior for fakes
- Fake#is_a? now returns true for superclasses of and modules included into the faked class.
- Reorganized the code into subdirectories

## 0.1.3

- Support for minitest
- Support nested constants in faked classes
- Fixed error in RSpec < 2.14

## 0.1.2

- Removed rspec warning about backtrace_clean_patterns

## 0.1.1

- Minor bugfixes to Ruby 2.0 support
- Support for Rubinius (head) and JRuby
- Overwrite described_class in on verify_contract
- Added with{} and any(Klass) argument matchers
- Added have_received(:name, args) syntax

## 0.1.0

- Support for stubbing on frozen fakes
- Safe stubbing of constructors
- Fixed spying on anonymous fakes
- Automatic handling of ActiveRecord columns
- Support Ruby 2.0 keyword arguments

### Breaking changes:

- Fakes no longer return themselves from unstubbed method calls, because this was often a source of confusion. In the new version we return a Bogus::UndefinedReturnValue which contains the method name and arguments from where it was returned.

## 0.0.4

- Support mocking methods with optional parameters

## 0.0.3

- Global fake configuration
- Inline method stubbing syntax
- Removed dependency on RR
- verifies_contracts records on described_class instead of class based on fake name
- Replacing classes with fakes
- Extracting common interface out of multpile classes to create duck types

## 0.0.2

- Makes it possible to stub method calls on objects that utilize method missing.
- Removed the need to require both bogus and bogus/rspec.
- Implemented anonymous fakes.
- Fixed a bug in copying ActiveRecord classes.
- (internal) Replaced autoloads with require.

## 0.0.1

Initial version.

- Fakes.
- Safe spying, stubbing, mocking.
- Veryfying contracts defined by test doubles.
