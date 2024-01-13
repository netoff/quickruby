test "assertion success with simple bool predicate" do
  @test_run = TestFile.run(<<-TEST_FILE
    test "pass" do
      assert true
    end
  TEST_FILE
  ) do |name, failure|
    assert name, "pass"
    assert failure.nil?
  end
end

test "assertion failure with simple bool predicate" do
  @test_run = TestFile.run(<<-TEST_FILE
    test "fail" do
      assert false
    end
  TEST_FILE
  ) do |name, failure|
    assert name, "fail"
    assert failure.message, "Assertion failed"
  end
end

test "assertion success with string predicate" do
  @test_run = TestFile.run(<<-TEST_FILE
    test "pass" do
      assert "foo", "foo"
    end
  TEST_FILE
  ) do |name, failure|
    assert name, "pass"
    assert failure.nil?
  end
end

test "assertion success with string predicate with partial match" do
  @test_run = TestFile.run(<<-TEST_FILE
    test "pass" do
      assert "foo", "oo"
    end
  TEST_FILE
  ) do |name, failure|
    assert name, "pass"
    assert failure.nil?
  end
end

test "assertion failure with string predicate" do
  out, err = capture_io do
    @test_run = TestFile.run(<<-TEST_FILE
      test "fail" do
        assert "foo", "bar"
      end
    TEST_FILE
    ) do |name, failure|
      assert name, "fail"
      assert failure.message, "Assertion failed"
    end
  end

  assert out.empty?
  assert err.include? "Expected \"foo\" to include \"bar\""
end

test "assertion success with method call on object" do
  @test_run = TestFile.run(<<-TEST_FILE
    test "pass" do
      assert nil, :nil?
      assert "", :empty?
    end
  TEST_FILE
  ) do |name, failure|
    assert name, "pass"
    assert failure, :nil?
  end
end
