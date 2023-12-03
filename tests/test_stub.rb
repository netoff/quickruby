# Do not pollute global namespace with class name
klass = Class.new do
  def self.foo()= "foo"
  def foo()= "#foo"
end

test "it can stub class methods" do
  assert klass.foo == "foo"
  klass.stub(:foo, "bar") do
    assert klass.foo == "bar"
  end
  assert klass.foo == "foo"
end

test "it can stub instance methods" do
  o = klass.new
  assert o.foo == "#foo"
  o.stub(:foo, "bar") do
    assert o.foo == "bar"
  end
end

test "it can stub singleton method on object" do
  o = Object.new
  def o.foo
    "#foo"
  end
  assert o.foo == "#foo"
  o.stub(:foo, "bar") do
    assert o.foo == "bar"
  end
  assert o.foo == "#foo"
end

test "it can stub instance method on any object of a class" do
  o = klass.new
  assert o.foo == "#foo"
  klass.stub_any_instance(:foo, "bar") do
    assert o.foo == "bar"
  end
  assert o.foo == "#foo"
end

test "it can not stub_any_instance on a object" do
  begin
    Object.new.stub_any_instance(:foo, "bar") {}
  rescue => e
    assert e.is_a?(NoMethodError)
  end
end