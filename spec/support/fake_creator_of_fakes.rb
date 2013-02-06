class FakeCreatorOfFakes
  def create(name, opts = {}, &block)
    fake = [name, opts, block && block.call]
    fakes << fake
    fake
  end

  def fakes
    @fakes ||= []
  end

  def has_created?(name, opts = {}, klass = nil)
    fakes.include?([name, opts, klass])
  end
end
