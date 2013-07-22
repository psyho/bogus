module Bogus
  module RSpecExtensions
    def fake(name, opts = {}, &block)
      let(name) { fake(name, opts, &block) }
    end

    def fake_class(name, opts = {})
      before do
        fake_class(name, opts)
      end
    end

    def verify_contract(name, &block)
      custom_class = block.call if block_given?
      old_described_class = described_class
      verified_class = custom_class || described_class

      before do
        new_class = Bogus.record_calls_for(name, verified_class)
        example.metadata[:example_group][:described_class] = new_class unless custom_class
      end

      after do
        example.metadata[:example_group][:described_class] = old_described_class unless custom_class
      end

      RSpec.configure do |config|
        config.after(:suite) { Bogus.verify_contract!(name) }
      end
    end
  end
end

