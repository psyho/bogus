# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bogus/version"

Gem::Specification.new do |s|
  s.name        = "bogus"
  s.version     = Bogus::VERSION
  s.authors     = ["Adam Pohorecki"]
  s.email       = ["adam@pohorecki.pl"]
  s.homepage    = "https://github.com/psyho/bogus"
  s.summary     = %q{Create fakes to make your isolated unit tests reliable.}
  s.description = %q{Decreases the need to write integration tests by ensuring that the things you stub or mock actually exist.}

  s.rubyforge_project = "bogus"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'dependor', '>= 0.0.4'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'aruba'

  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-cucumber'
  s.add_development_dependency 'guard-ctags-bundler'
  s.add_development_dependency 'growl'
  s.add_development_dependency 'libnotify'
  s.add_development_dependency 'rr'
end
