require_relative 'node_builder'

module Quickruby
  module Build
    module Web
      class RubyFile
        def self.run(file)
          builder = NodeBuilder.new.instance_eval(file)

          if builder.is_a?(String)
            builder
          elsif builder.respond_to?(:call)
            builder.call
          else
            raise ArgumentError.new("file must be a string or respond to call")
          end
        end
      end
    end
  end
end