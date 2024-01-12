test "around is called if there is at least one tes" do
  test_file = <<-TEST_FILE
    around do |test|
      test.call
    end

    test "pass" do
      assert true
    end
  TEST_FILE

  test_file_round = TestFile.run(test_file)

  assert test_file_round.assertions == 1
  assert test_file_round.failures == 0
end

test "around is not called if no tests" do
  test_file = <<-TEST_FILE
    around do |test|
      test.call
    end
  TEST_FILE

  test_file_round = TestFile.run(test_file)

  assert test_file_round.assertions == 0
  assert test_file_round.failures == 0
end

test "around can not be called twice" do
  test_file = <<-TEST_FILE
    around do |test|
      test.call
    end

    around do |test|
      test.call
    end
  TEST_FILE

  err = begin
    TestFile.run(test_file)
  rescue => e
    e
  end

  assert err.message == "around already defined"
end
