require 'spec_helper'

describe Bogus::MultiStubber do
  let(:double) { FakeDouble.new }
  let(:create_double) { proc{ double } }
  let(:any_args) { Bogus::AnyArgs }

  let(:multi_stubber) { isolate(Bogus::MultiStubber) }

  it "stubs all the given methods with any args returning the given value" do
    multi_stubber.stub_all(Object.new, foo: 1, bar: 2)

    double.stubbed.should == [[:foo, [any_args], 1], [:bar, [any_args], 2]]
  end

  class FakeDouble
    def stubbed
      @stubbed ||= []
    end

    def stubs(name, *args, &return_value)
      stubbed << [name, args, return_value.call]
    end
  end
end
