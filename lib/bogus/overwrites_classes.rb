class Bogus::OverwritesClasses
  def overwrite(full_name, new_klass)
    modules = full_name.split('::')
    klass_name = modules.pop
    parent_module = modules.reduce(Object) { |mod, name| mod.const_get(name) }
    parent_module.send(:remove_const, klass_name)
    parent_module.const_set(klass_name, new_klass)
  end
end
