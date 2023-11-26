require 'test_helper'

require 'open3'

class TestBootstrap < Minitest::Test
  def test_running_tests_with_wrong_command
    change_dir do
      # Note it is `tests` not `test`
      Open3.popen3('ruby app.rb tests') do |stdin, stdout, stderr, wait_thr|
        e = stderr.read
        assert_includes e, "Command not found: tests"

        assert !wait_thr.value.success?
      end
    end
  end
  def test_running_tests
    change_dir do
      Open3.popen3('ruby app.rb test') do |stdin, stdout, stderr, wait_thr|
        assert_empty stderr.read
        assert stdout.read.include?('Running tests...')

        assert wait_thr.value.success?
      end
    end
  end
  
  def test_pass
    change_dir do
      Open3.popen3('ruby app.rb test tests/test_pass.rb') do |stdin, stdout, stderr, wait_thr|
        assert_empty stderr.read
        assert_includes stdout.readlines.last, '1 test file, 1 test case, 1 assertion, 0 failures'

        assert wait_thr.value.success?
      end 
    end
  end

  def test_fail
    change_dir do
      Open3.popen3('ruby app.rb test test_fail.rb') do |stdin, stdout, stderr, wait_thr|
        assert_includes stderr.read, "Assertion failed, error in test_fail.rb:2 in `test fail`"
        assert_includes stdout.read, '1 test file, 1 test case, 1 assertion, 1 failure'

        assert !wait_thr.value.success?
      end
    end
  end

  def test_non_existing_file
    change_dir do
      Open3.popen3('ruby app.rb test tests/non_existing_file.rb') do |stdin, stdout, stderr, wait_thr|
        assert_includes stderr.read, "No such file or directory @ rb_sysopen - tests/non_existing_file.rb (Errno::ENOENT)"

        assert !wait_thr.value.success?
      end
    end
  end

  def test_empty_file
    change_dir do
      Open3.popen3('ruby app.rb test test_empty.rb') do |stdin, stdout, stderr, wait_thr|
        assert_empty stderr.read
        assert_includes stdout.readlines.last, '1 test file, 0 test cases, 0 assertions, 0 failures'

        assert wait_thr.value.success?
      end
    end
  end

  def test_multiple_tests_cases
    change_dir do
      Open3.popen3('ruby app.rb test test_multiple_pass_cases.rb') do |stdin, stdout, stderr, wait_thr|
        assert_empty stderr.read
        assert_includes stdout.readlines.last, '1 test file, 2 test cases, 2 assertions, 0 failures'

        assert wait_thr.value.success?
      end
    end
  end

  def test_multiple_test_cases_with_failure
    change_dir do
      Open3.popen3('ruby app.rb test test_multiple_fail_cases.rb') do |stdin, stdout, stderr, wait_thr|
        assert_includes stderr.read, "Assertion failed, error in test_multiple_fail_cases.rb:6 in `test second fail`"
        assert_includes stdout.readlines.last, '1 test file, 3 test cases, 3 assertions, 1 failure'

        assert !wait_thr.value.success?
      end
    end
  end

  private

  def change_dir
    Dir.chdir('dummy') { yield }
  end

end