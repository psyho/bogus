class Bogus::VerifiesStubDefinition
  def verify!(object, method_name, args)
    stubbing_non_existent_method!(object, method_name) unless object.respond_to?(method_name)
  end

  private

  def stubbing_non_existent_method!(object, method_name)
    raise Bogus::StubbingNonExistentMethod, "#{object} does not respond to #{method_name}"
  end
end
