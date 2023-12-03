class Object
  def stub(m, value)
    old_method = method(m).unbind

    define_singleton_method(m) { value }

    yield

    define_singleton_method(m, old_method)
  end
end

class Module
  def stub_any_instance(m, value)
    old_method = instance_method(m)

    define_method(m) { value }

    yield

    define_method(m, old_method)
  end
end