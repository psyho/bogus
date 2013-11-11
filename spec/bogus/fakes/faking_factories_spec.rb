require 'spec_helper'

describe "Faking Factories" do
  include Bogus::MockingDSL

  class ExampleFactory
    def initialize(model_class)
      @model_class = model_class
    end

    def create(y)
      @model_class.new(1, y)
    end
  end

  class ExampleModel1
    def initialize(x, y)
    end
  end

  it "allows spying on factory classes" do
    model_class = fake(:example_model, as: :class) { ExampleModel1 }
    factory = ExampleFactory.new(model_class)

    factory.create(2)

    expect(model_class).to have_received.new(1, 2)
  end

  class ExampleModel2
    def initialize(x, y, z)
    end
  end

  it "retains the arity safety" do
    model_class = fake(:example_model, as: :class) { ExampleModel2 }
    factory = ExampleFactory.new(model_class)

    expect {
      factory.create(2)
    }.to raise_error(ArgumentError)
  end

  class ExampleModel3
  end

  it "works with classes with no explicit constructor" do
    model_class = fake(:example_model, as: :class) { ExampleModel3 }

    model = model_class.new

    expect(model_class).to have_received.new
  end

  class ExampleModel4
    def initialize(y)
    end

    def foo(x)
    end
  end

  it "allows creating the model instances as usual" do
    model = fake(:example_model) { ExampleModel4 }

    model.foo(1)

    expect(model).to have_received.foo(1)
  end

  module ExampleModel5
    def self.foo(x)
    end
  end

  it "allows creating fakes of modules as usual" do
    model = fake(:example_model, as: :class) { ExampleModel5 }

    model.foo(1)

    expect(model).to have_received.foo(1)
  end
end
