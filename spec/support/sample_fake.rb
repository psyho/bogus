module Samples
  class Foo
    def foo(a, b)
      "the real foo: #{a} #{b}"
    end

    def bar
      "the real bar"
    end
  end

  FooFake = Bogus::Injector.new.copies_classes.copy(Foo)
end
