module Quickruby
  module Build
    module Web
      class NodeBuilder
        TAGS = %i(html head title body h1)

        attr_reader :children
        def initialize()
          @children = []
        end

        def method_missing(method_name, *args, &block)
          if TAGS.include?(method_name)
            @children << proc {
              if args.size == 1 && args.first.is_a?(String)
                "<#{method_name}>#{args.first}</#{method_name}>"
              elsif block_given?
                children = NodeBuilder.new.instance_eval(&block)
                 "<#{method_name}>#{children.call}</#{method_name}>"
              end
            }

            self
          else
            super
          end
        end

        def respond_to_missing?(method_name, include_private = false)
          TAGS.include?(method_name) || super
        end
        def call
          @children.map(&:call).join
        end
      end
    end
  end
end