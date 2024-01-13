require "open3"

around do |test|
  Dir.chdir("dummy") {
    #    remove `build` output folder if it exists
    FileUtils.rm_rf("build")

    test.call

    # clean up after test
    FileUtils.rm_rf("build")
  }
end

test "it produces a simple page" do
  assert !File.exist?("build/index.html")
  assert !File.exist?("build/pages/index.html")
  assert !File.exist?("build/pages/page.html")

  Open3.popen3("ruby app.rb build") do |_, stdout, stderr, wait_thr|
    assert stderr.read, :empty?
    assert stdout.readlines.first, "Building..."

    assert wait_thr.value.success?
  end

  assert File.read("build/index.html"), "<h1>Hello, World!</h1>"
  assert File.read("build/pages/index.html"), "<h1>Index</h1>"
  assert File.read("build/pages/page.html"), "<h1>Page</h1>"
end