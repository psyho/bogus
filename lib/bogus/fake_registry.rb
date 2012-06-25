class Bogus::FakeRegistry
  def initialize
    @registry = {}
  end

  def store(name, object)
    @registry[object.object_id] = name
  end

  def name(object)
    @registry[object.object_id]
  end
end
