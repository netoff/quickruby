require "open3"

test "it loads tests files recursively" do
  Dir.chdir("dummy") do
    test = Quickruby::Tests.new.run
    assert test.files == 2
  end
end
