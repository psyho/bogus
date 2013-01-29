## Installation

To install Bogus, all you need to do is add:

    gem "bogus"

to your Gemfile.

## Configuration

In your `spec_helper.rb`, require bogus:

    require 'bogus/rspec'

And configure it to look for classes in your namespace:

    Bogus.configure do |c|
      c.search_modules << My::Namespace
    end

You will probably also want to create a configuration file for your 
fakes (for example `spec/support/fakes.rb`):

    Bogus.fakes do
      # fakes go here
    end

and require it in your gem file:

    require_relative 'support/fakes.rb'
