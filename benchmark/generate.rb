#!/usr/bin/env ruby

require 'securerandom'

alphabet = ('a'..'z').to_a
num_classes = 200
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

class_names = num_classes.times.map do
  alphabet.sample(5).join
end

classes = class_names.map do |name|
  other_classes = class_names - [name]
  num_dependencies = dependencies_per_class.sample
  dependencies = other_classes.sample(num_dependencies)
  Klass.create(name: name, dependency_names: dependencies)
end

classes.take(5).each do |k|
  puts KlassBodyPresenter.new(k).body
end
