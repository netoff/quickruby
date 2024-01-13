require 'pathname'

require_relative 'file'

module Quickruby
  module Build
    module Web
      module Builder
        extend self
        def run
          pwd = Pathname.pwd
          web_dir = pwd.join("web")
          output_dir = pwd.join("build")
          output_dir.mkdir unless output_dir.exist?

          puts "about to build"

          web_dir.glob("**/*.rb").each do |web_file|
            output_file_name = web_file.basename('.rb').sub_ext('.html')
            output_file = output_dir.join(web_file.relative_path_from(web_dir).dirname.join(output_file_name))

            puts "writing to #{output_file}"
            output_file.write Web::File.run(web_file.read)
          end
        end
      end
    end
  end
end