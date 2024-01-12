# Test we are able to bootstrap the tests itself
# So we 'bootstrap' quickruby tests with itself

require "open3"

around do |test|
  Dir.chdir("dummy") {
    test.call
  }
end

test "running tests with wrong command" do
  # Note it is `tests` not `tests`
  Open3.popen3("ruby app.rb test") do |_, _, stderr, wait_thr|
    assert stderr.read, "Command not found: test"
    process_status = wait_thr.value
    assert process_status.exited?
    assert process_status.exitstatus == 1
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
    assert stdout.readlines.last.include? "1 tests file, 1 tests case, 1 assertion, 0 failures"

    assert wait_thr.value.success?
    assert wait_thr.value.exitstatus == 0
  end
end

test "fail" do
  Open3.popen3("ruby app.rb tests test_fail.rb") do |_, stdout, stderr, wait_thr|
    assert stderr.read.include? "Assertion failed, error in test_fail.rb:2 in `tests fail`"
    assert stdout.read.include? "1 tests file, 1 tests case, 1 assertion, 1 failure"

    assert !wait_thr.value.success?
  end
end

test "non existing file" do
  Open3.popen3("ruby app.rb tests tests/non_existing_file.rb") do |_, _, stderr, wait_thr|
    assert stderr.read.include? "No such file or directory @ rb_sysopen - tests/non_existing_file.rb (Errno::ENOENT)"
    process_status = wait_thr.value
    assert process_status.exited?
    assert process_status.exitstatus == 1
  end
end

test "empty file" do
  Open3.popen3("ruby app.rb tests test_empty.rb") do |_, stdout, stderr, wait_thr|
    assert stderr.read.empty?
    assert stdout.readlines.last.include? "1 tests file, 0 tests cases, 0 assertions, 0 failures"
    assert wait_thr.value.success?
    assert wait_thr.value.exitstatus == 0
  end
end

test "multiple tests cases" do
  Open3.popen3("ruby app.rb tests test_multiple_pass_cases.rb") do |_, stdout, stderr, wait_thr|
    assert stderr.read.empty?
    assert stdout.readlines.last.include? "1 tests file, 2 tests cases, 2 assertions, 0 failures"

    assert wait_thr.value.success?
    assert wait_thr.value.exitstatus == 0
  end
end

test "multiple tests cases with failure" do
  Open3.popen3("ruby app.rb tests test_multiple_fail_cases.rb") do |_, stdout, stderr, wait_thr|
    assert stderr.read.include? "Assertion failed, error in test_multiple_fail_cases.rb:6 in `tests second fail`"
    assert stdout.readlines.last.include? "1 tests file, 3 tests cases, 3 assertions, 1 failure"

    assert wait_thr.value.exitstatus == 1
  end
end
