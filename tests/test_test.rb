require 'open3'

test "it loads test files recursively" do
  Dir.chdir('dummy') do
    test = Quickruby::Test.new.run

    assert test.files == 2
  end
end
