#!/usr/bin/env ruby

require 'securerandom'

alphabet = ('a'..'z').to_a
num_classes = (ARGV[0] || 200).to_i
dependencies_per_class = [1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5]

class Klass
  attr_reader :name

  def initialize(opts = {})
    @name = opts[:name]
    @dependency_names = opts[:dependency_names]
  end

  def as_const
    name[0].upcase + name[1..-1]
  end

  def as_sym
    ":#{name}"
  end

  def as_var
    name
  end

  def dependencies
    @dependency_names.map do |name|
      Klass.for_name(name)
    end
  end

  def self.create(opts = {})
    klass = new(opts)
    all[klass.name] = klass
    klass
  end

  def self.for_name(name)
    all.fetch(name)
  end

  def self.all
    @all ||= {}
  end
end

class KlassBodyPresenter
  attr_reader :klass

  def initialize(klass)
    @klass = klass
  end

  def body
<<EOF
class #{klass.as_const}
  #{attr_readers}

#{constructor}

#{methods}

  def foo(x)
    # do nothing
  end
end
EOF
  end

  def attr_readers
    deps = klass.dependencies.map(&:as_sym)
    "attr_reader #{deps.join(', ')}"
  end

  def constructor
    assignments = klass.dependencies.map do |dep|
      "@#{dep.as_var} = #{dep.as_var}"
    end
    args = klass.dependencies.map(&:as_var)

<<EOF
  def initialize(#{args.join(', ')})
    #{assignments.join("\n    ")}
  end
EOF
  end

  def methods
    klass.dependencies.map do |d|
<<EOF
  def call_#{d.as_var}(x)
    #{d.as_var}.foo(x + 1)
  end
EOF
    end.join("\n\n")
  end
end

class BogusDSL
  def configure
    "require 'bogus/rspec'"
  end

  def dependency(klass)
    "fake(#{klass.as_sym})"
  end

  def stub_method(dep)
    "stub(#{dep.as_var}).foo(2) { :hello }"
  end

  def subject(klass)
    deps = klass.dependencies.map(&:as_var)
    "let(#{klass.as_sym}) { #{klass.as_const}.new(#{deps.join(", ")}) } "
  end
end

class BogusIsolateDSL < BogusDSL
  def configure
    <<-EOF
    require 'bogus/rspec'
    require 'dependor/rspec'
    EOF
  end

  def subject(klass)
    "let(#{klass.as_sym}) { isolate(#{klass.as_const}) } "
  end
end

class BogusNoFakesDSL < BogusDSL
  def dependency(klass)
    "let(#{klass.as_sym}) { #{klass.as_const}.new(#{klass.dependencies.map{"nil"}.join(', ')}) }"
  end
end

class RspecDSL
  def configure
  end

  def dependency(klass)
    "let(#{klass.as_sym}) { double }"
  end

  def stub_method(dep)
    "#{dep.as_var}.stub(:foo).with(2).and_return(:hello)"
  end

  def subject(klass)
    deps = klass.dependencies.map(&:as_var)
    "let(#{klass.as_sym}) { #{klass.as_const}.new(#{deps.join(", ")}) } "
  end
end

class RspecFireDSL
  def configure
<<EOF
require 'rspec/fire'

RSpec.configure do |config|
  config.include(RSpec::Fire)
end
EOF
  end

  def dependency(klass)
    "let(#{klass.as_sym}) { instance_double('#{klass.as_const}') }"
  end

  def stub_method(dep)
    "#{dep.as_var}.stub(:foo).with(2).and_return(:hello)"
  end

  def subject(klass)
    deps = klass.dependencies.map(&:as_var)
    "let(#{klass.as_sym}) { #{klass.as_const}.new(#{deps.join(", ")}) } "
  end
end

class KlassSpecPresenter
  attr_reader :klass, :dsl

  def initialize(klass, dsl)
    @klass = klass
    @dsl = dsl
  end

  def body
<<EOF
require_relative '../spec_helper'

describe #{klass.as_const} do
#{fakes.join("\n")}

  #{subject}

#{examples.join("\n\n")}
end
EOF
  end

  def subject
    dsl.subject(klass)
  end

  def fakes
    klass.dependencies.map do |d|
      dsl.dependency(d)
    end
  end

  def examples
    klass.dependencies.map do |d|
<<EOF
  it "calls #{d.as_var}" do
    #{dsl.stub_method(d)}

    #{klass.as_var}.call_#{d.as_var}(1).should == :hello
  end
EOF
    end
  end
end

def save_manifest(classes)
  requires = classes.map do |c|
    %Q[require "klasses/#{c.as_var}"]
  end
  manifest = <<EOF
$: << File.expand_path("..", __FILE__)

#{requires.join("\n")}
EOF

  File.write("lib/project.rb", manifest)
end

def save_spec_helper(dsl, path)
  File.write "#{path}/spec_helper.rb", <<EOF
require_relative "../lib/project.rb"

#{dsl.configure}

RSpec.configure do |c|
  c.color_enabled = true

  if ENV['PROFILE']
    c.before(:suite) do
      require 'ruby-prof'

      RubyProf.start
    end

    c.after(:suite) do
      result = RubyProf.stop
      printer = RubyProf::CallTreePrinter.new(result)

      File.open("profile.kcg", "w") do |f|
        printer.print(f, :min_percent => 2)
      end
    end
  end
end
EOF
end

def save_specs(dsl, path, classes)
  FileUtils.rm_rf(path)
  FileUtils.mkdir_p("#{path}/klasses")

  save_spec_helper(dsl, path)
  classes.each do |c|
    spec_presenter = KlassSpecPresenter.new(c, dsl)
    File.write("#{path}/klasses/#{c.as_var}_spec.rb", spec_presenter.body)
  end
end

class_names = num_classes.times.map do
  alphabet.sample(5).join
end

classes = class_names.map do |name|
  other_classes = class_names - [name]
  num_dependencies = dependencies_per_class.sample
  dependencies = other_classes.sample(num_dependencies)
  Klass.create(name: name, dependency_names: dependencies)
end

require 'fileutils'

FileUtils.rm_rf("lib")
FileUtils.mkdir_p("lib/klasses")

classes.each do |k|
  body = KlassBodyPresenter.new(k).body
  File.write("lib/klasses/#{k.name}.rb", body)
end

save_manifest(classes)
save_specs(BogusDSL.new, "spec_bogus", classes)
save_specs(BogusNoFakesDSL.new, "spec_no_fakes", classes)
save_specs(BogusIsolateDSL.new, "spec_bogus_isolate", classes)
save_specs(RspecDSL.new, "spec_rspec", classes)
save_specs(RspecFireDSL.new, "spec_fire", classes)

