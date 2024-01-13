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

  Open3.popen3("ruby app.rb build") do |_, stdout, stderr, wait_thr|
    assert stderr.read, :empty?
    assert stdout.readlines.first, "Building..."

    assert wait_thr.value.success?
  end

  assert File.exist?("build/index.html")

  html = File.read("build/index.html")
  assert html, "<h1>Hello, World!</h1>"
end