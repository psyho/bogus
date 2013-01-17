class Bogus::RegistersCreatedFakes
  extend Bogus::Takes

  takes :creates_fakes, :fake_registry, :double_tracker

  def create(name, opts = {}, &block)
    fake = creates_fakes.create(name, opts, &block)
    fake_registry.store(name, fake)
    double_tracker.track(fake)
    fake
  end
end
