module RubyFeatures
  module_function

  def keyword_arguments?
    ruby?('2.0') && !rbx?
  end

  def required_keyword_arguments?
    ruby?('2.1') && keyword_arguments?
  end

  def ruby?(version)
    RUBY_VERSION >= version
  end

  def rbx?
    RUBY_ENGINE == 'rbx'
  end
end
