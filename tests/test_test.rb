require "open3"

test "it loads tests files recursively" do
  Dir.chdir("dummy") do
    Kernel.stub(:puts, nil) do
      Kernel.stub(:print, nil) do
        test = Quickruby::Tests.new.run

        assert test.files == 2
      end
    end
  end
end
