require_relative './test_file.rb'

require 'active_support/inflector'
require 'colorize'

module Quickruby

  class Test
    def initialize
      @files = @test_cases = @assertions = @failures = 0
    end

    def run
      print "Running tests..."

      do_test_runs
      print_summary

      exit @failures == 0
    end

    private

    def count(number, word)
      "#{number} #{word.pluralize(number)}"
    end
    def print_summary
      puts "Success🎉".colorize(:green) if @failures == 0
      puts "\n\n#{count(@files, 'test file')}, " +
             "#{count(@test_cases, 'test case')}, " +
             "#{count(@assertions, 'assertion')}, " +
             "#{count(@failures, 'failure')}"
    end

    def do_test_runs
      if ARGV[1]
        @files = 1
        do_test_run(ARGV[1])
      else
        Dir.glob('tests/test_*.rb') do |file|
          @files += 1
          do_test_run(file)
        end
      end
    end

    def do_test_run(file)
      pathname = Pathname.new(file)

      test_run = TestFile.run(pathname.read) do |name, failure|
        STDERR.puts "Assertion failed, error in #{file}:#{failure.caller[0].split(':')[1]} in `test #{name}`"
      end

      @test_cases += test_run.test_cases.size
      @assertions += test_run.assertions
      @failures += test_run.failures
    end
  end
end