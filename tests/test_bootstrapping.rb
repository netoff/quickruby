# Test we are able to bootstrap the tests itself
# So we 'bootstrap' quickruby test with itself

require "open3"

around do |test|
  Dir.chdir("dummy") {
    test.call
  }
end

test "running tests with wrong command" do
  # Note it is `tests` not `test`
  Open3.popen3("ruby app.rb test") do |_, _, stderr, wait_thr|
    assert stderr.read.include? "Command not found: test"
    assert !wait_thr.value.success?
  end
end

test "running tests" do
  Open3.popen3("ruby app.rb tests") do |_, stdout, stderr, wait_thr|
    assert stderr.read.empty?
    assert stdout.read.include?("Running tests...")

    assert wait_thr.value.success?
  end
end

test "pass" do
  Open3.popen3("ruby app.rb tests tests/test_pass.rb") do |_, stdout, stderr, wait_thr|
    assert stderr.read.empty?
    assert stdout.readlines.last.include? "1 test file, 1 test case, 1 assertion, 0 failures"

    assert wait_thr.value.success?
  end
end

test "fail" do
  Open3.popen3("ruby app.rb tests test_fail.rb") do |_, stdout, stderr, wait_thr|
    assert stderr.read.include? "Assertion failed, error in test_fail.rb:2 in `test fail`"
    assert stdout.read.include? "1 test file, 1 test case, 1 assertion, 1 failure"

    assert !wait_thr.value.success?
  end
end

test "non existing file" do
  Open3.popen3("ruby app.rb tests tests/non_existing_file.rb") do |_, _, stderr, wait_thr|
    assert stderr.read.include? "No such file or directory @ rb_sysopen - tests/non_existing_file.rb (Errno::ENOENT)"
    assert !wait_thr.value.success?
  end
end

test "empty file" do
  Open3.popen3("ruby app.rb tests test_empty.rb") do |_, stdout, stderr, wait_thr|
    assert stderr.read.empty?
    assert stdout.readlines.last.include? "1 test file, 0 test cases, 0 assertions, 0 failures"
    assert wait_thr.value.success?
  end
end

test "multiple tests cases" do
  Open3.popen3("ruby app.rb tests test_multiple_pass_cases.rb") do |_, stdout, stderr, wait_thr|
    assert stderr.read.empty?
    assert stdout.readlines.last.include? "1 test file, 2 test cases, 2 assertions, 0 failures"

    assert wait_thr.value.success?
  end
end

test "multiple test cases with failure" do
  Open3.popen3("ruby app.rb tests test_multiple_fail_cases.rb") do |_, stdout, stderr, wait_thr|
    assert stderr.read.include? "Assertion failed, error in test_multiple_fail_cases.rb:6 in `test second fail`"
    assert stdout.readlines.last.include? "1 test file, 3 test cases, 3 assertions, 1 failure"

    assert !wait_thr.value.success?
  end
end
