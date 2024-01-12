require "open3"

test "it properly reports exception in test and its line" do
  Dir.chdir("dummy") do
    Open3.popen3("ruby app.rb tests tests/exception.rb") do |_, _, stderr, wait_thr|
      assert stderr.read.include? "fail, error in tests/exception.rb:15 in `test fail`"
      assert !wait_thr.value.success?
    end
  end
end
