module Quickruby
  module Build
    module Web
      class File
        def self.run(file)
          file_builder = Class.new.class_eval(file)
          file_builder.call
        end
      end
    end
  end
end