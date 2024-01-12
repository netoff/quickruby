require 'benchmark'

require_relative './runners/tests'
require_relative './runners/build'

module Quickruby
  module Runner
    extend self

    def run
      if ARGV.size > 0
        command = ARGV[0]

        case command
        when "tests"
          Runners::Tests.new.run ARGV[1]
        when "build"
          Runners::Build.new.run
        else
          if $0 == "app.rb"
            $stderr.puts "Command not found: #{command}"

            exit 1
          end
        end
      else
        # By default run tests
        Runners::Tests.new.run ARGV[1]
      end
    end
  end
end