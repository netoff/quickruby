require 'erubi'

module Quickruby
  module Build
    module Web
      class NodeBuilder
        VALID_TAGS = eval("%i[#{File.read(File.expand_path("valid_tags.txt", File.dirname(__FILE__)))}]")

        attr_reader :tag, :children, :classes, :id, :style
        def initialize
          @children = []
          @classes = []
        end

        def method_missing(method_name, *args, &block)
          puts "===> #{tag}"
          if tag && children.empty?
            puts "addings classes: #{tag} #{method_name}"
            @classes << method_name.to_s.gsub("_", "-")
          elsif VALID_TAGS.include?(method_name) && !tag
            @tag = method_name
          else
            raise "invalid HTML tag `#{method_name}` #{tag}"
          end

          if args.size == 1 && args.first.is_a?(String)
            puts "string===> #{method_name}, #{tag}, #{children.inspect}"
            @children << proc { args.first }
          elsif block_given?
            puts "block===> #{method_name}, #{tag}, #{children.inspect}"
            @children << NodeBuilder.new.instance_eval(&block)
          end

          # puts "returning self: #{self.tag}"
          # self
        end

        def respond_to_missing?(method_name, include_private = false)
          VALID_TAGS.include?(method_name) || !tag.nil? || super
        end

        def call
          eval(Erubi::Engine.new(<<-ELEMENT_TEMPLATE.squish.strip).src)
            <<%= tag %>><%= children.map(&:call).join if children.any? %></<%= tag %>>
          ELEMENT_TEMPLATE
        end
      end
    end
  end
end