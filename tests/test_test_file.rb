test "it can have multimple tests" do
  test_file = <<-TEST_FILE
    test "pass" do
      assert true
    end
  
    test "pass1" do
      assert true
    end
  TEST_FILE

  test_file_run = TestFile.run(test_file)

  assert test_file_run.test_cases.size == 2
  assert test_file_run.assertions == 2
  assert test_file_run.failures == 0
end

test "it can not have multiple tests with same name" do
  test_file = <<-TEST_FILE
    test "pass" do
      assert true
    end
  
    test "pass" do
      assert true
    end
  TEST_FILE

  err = nil

  begin
    TestFile.run(test_file)
  rescue => e
    err = e
  end

  assert err.message == "test `pass` already defined"
end

test "it count exception within test as failure" do
  test_file = <<-TEST_FILE
    test "pass" do
      raise "fail"
    end
  TEST_FILE

  test_file_run = TestFile.run(test_file)

  assert test_file_run.failures == 1
end