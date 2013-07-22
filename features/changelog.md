## 0.1.4 (in progress)

- Support for contracts in minitest

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
