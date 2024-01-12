require "open3"

test "it properly reports exception in test and its line" do
  Dir.chdir("dummy") do
    Open3.popen3("ruby app.rb tests tests/fail.rb") do |_, _, stderr, wait_thr|
      assert stderr.read.include? "Assertion failed, error in tests/fail.rb:12 in `test fail`"
      assert !wait_thr.value.success?
    end
  end
end
