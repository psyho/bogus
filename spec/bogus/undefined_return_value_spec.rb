require 'spec_helper'

describe Bogus::UndefinedReturnValue do
  let(:interaction) { Bogus::Interaction.new(:foo, ["bar"]) }
  let(:undefined_return_value) { Bogus::UndefinedReturnValue.new(interaction) }

  it "includes the interaction when stringified" do
    undefined_return_value.to_s.should include('foo("bar")')
  end

  it "includes interaction in the error message unknown method called" do
    begin
      undefined_return_value.foobar
    rescue => e
      e.message.should include('foo("bar")')
    end
  end
end
