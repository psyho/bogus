module Bogus
  class AddsContractVerification
    extend Takes
    takes :adds_recording, :verifies_contracts, :converts_name_to_class, :syntax

    def add(fake_name, &block)
      old_described_class = syntax.described_class

      before do
        new_class = adds_recording.add(fake_name, class_to_overwrite(fake_name, block))
        syntax.described_class = new_class if overwritten_described_class?(block)
      end

      after do
        syntax.described_class = old_described_class if overwritten_described_class?(block)
      end

      after_suite { verifies_contracts.verify(fake_name) }
    end

    private

    def overwritten_described_class?(block)
      described_class && !custom_class(block)
    end

    def class_to_overwrite(fake_name, block)
      custom_class(block) || described_class || fake_class(fake_name)
    end

    def custom_class(block)
      block.call if block
    end

    def described_class
      syntax.described_class
    end

    def fake_class(name)
      converts_name_to_class.convert(name)
    end

    def after_suite(&block)
      syntax.after_suite { block.call }
    end

    def after(&block)
      syntax.after { block.call }
    end

    def before(&block)
      syntax.before { block.call }
    end
  end
end
