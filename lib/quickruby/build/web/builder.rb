require 'pathname'

require_relative 'ruby_file'

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

          web_dir.glob("**/*.{rb,html}").each do |web_file|
            extname = web_file.extname
            output_file_name = web_file.basename(extname).sub_ext('.html')
            output_file = output_dir.join(web_file.relative_path_from(web_dir).dirname.join(output_file_name))

            puts "writing to #{output_file}"
            output_file.parent.mkpath

            if extname == ".rb"
              output_file.write Web::RubyFile.run(web_file.read)
            elsif extname == ".html"
              output_file.write web_file.read
            end
          end
        end
      end
    end
  end
end