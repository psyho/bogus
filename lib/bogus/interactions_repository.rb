class Bogus::InteractionsRepository
  def initialize
    @interactions = Hash.new { |hash, fake_name| hash[fake_name] = [] }
  end

  def record(fake_name, method, *args)
    @interactions[fake_name] << [method, *args]
  end

  def recorded?(fake_name, method, *args)
    @interactions[fake_name].include?([method, *args])
  end

  def for_fake(fake_name)
    @interactions[fake_name]
  end
end
