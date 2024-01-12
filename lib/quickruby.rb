# frozen_string_literal: true

require_relative "quickruby/version"

require 'benchmark'

module Quickruby
  # Do we need this?
  # class Error < StandardError; end
  class Runner
    attr_reader :tests

    def run
      if ARGV.size > 0
        command = ARGV[0]

        case command
        when "tests"
          require_relative "quickruby/tests/tests"

          puts "Running tests:\n"

          benchmark = Benchmark.realtime { @tests = Tests.new.run ARGV[1] }

          puts "Success🎉".colorize(:green) if tests.failures == 0

          puts " (#{benchmark.round(2)}s)"
          puts tests.summary

          exit 1 if tests.failures > 0
        else
          if $0 == "app.rb"
            $stderr.puts "Command not found: #{command}"

            exit 1
          end
        end
      else
        puts "Runnig app..."
      end
    end
  end
end

Quickruby::Runner.new.run
