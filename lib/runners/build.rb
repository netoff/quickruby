require_relative '../quickruby/build/builder'


module Quickruby
  module Runners
    class Build
      def run
        Quickruby::Build::Builder.new.run
      end
    end
  end
end