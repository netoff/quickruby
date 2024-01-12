require_relative "../quickruby/tests/tests"

module Quickruby
  module Runners

    class Tests
      attr_reader :tests

      def run(file = nil)
        puts "Running tests:\n"

        benchmark = Benchmark.realtime { @tests = Quickruby::Tests.new.run file }

        puts "Success🎉".colorize(:green) if tests.failures == 0

        puts " (#{benchmark.round(2)}s)"
        puts tests.summary

        exit 1 if tests.failures > 0
      end
    end
  end
end