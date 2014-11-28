require 'spec_helper'

class ExampleForRbxJRubyBug
  def self.bar(argument)
    argument
  end

  def self.foo(argument)
    argument
  end

  def initialize(*args)
    args
  end
end

describe ExampleForRbxJRubyBug do
  before do
    extend Bogus::MockingDSL
  end

  context '.bar' do
    specify 'stubbing class twice in example' do
      stub(ExampleForRbxJRubyBug).bar('same_argument')
      stub(ExampleForRbxJRubyBug).bar('same_argument')
    end
  end

  context '.foo' do
    specify 'stubbing class once in example' do
      stub(ExampleForRbxJRubyBug).foo('same_argument')
    end

    specify 'stubbing class once in another example' do
      stub(ExampleForRbxJRubyBug).foo('same_argument')
    end
  end

  context '.new' do
    before  { stub(ExampleForRbxJRubyBug).new(any_args) }

    specify { ExampleForRbxJRubyBug.new(1, 2, 3) }
    specify { ExampleForRbxJRubyBug.new(1, 2, 3) }
  end
end
