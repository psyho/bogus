## Installation

To install Bogus, all you need to do is add:

    gem "bogus"

to your Gemfile.

## Configuration

In your `spec_helper.rb`, require bogus:

    require 'bogus/rspec'

Bogus will hook into RSpec on it's own, but if you want to be explicit about the used mock framework, you can put this in your `spec_helper.rb`:

    RSpec.configure do |c|
      # already done by requiring bogus/rspec
      c.mock_with Bogus::RSpecAdapter
    end

And configure it to look for classes in your namespace:

    Bogus.configure do |c|
      c.search_modules << My::Namespace
    end

You will probably also want to create a configuration file for your fakes (for example `spec/support/fakes.rb`):

    Bogus.fakes do
      # fakes go here
    end

and require it in your gem file:

    require_relative 'support/fakes.rb'
