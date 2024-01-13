require_relative 'web/builder'

module Quickruby
  module Build
    class Builder
      def run
        puts "Building..."

        Web::Builder.run
      end
    end
  end
end