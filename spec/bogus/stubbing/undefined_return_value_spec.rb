require 'spec_helper'

describe Bogus::UndefinedReturnValue do
  let(:interaction) { Bogus::Interaction.new(:foo, ["bar"]) }
  let(:undefined_return_value) { Bogus::UndefinedReturnValue.new(interaction) }

  it "includes the interaction when stringified" do
    expect(undefined_return_value.to_s).to include('foo("bar")')
  end

  it "includes interaction in the error message unknown method called" do
    begin
      undefined_return_value.foobar
    rescue => e
      expect(e.message).to include('foo("bar")')
    end
  end
end
