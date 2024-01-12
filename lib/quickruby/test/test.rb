require_relative "test_file"
require_relative "stub"

require "active_support/inflector"
require "active_support/core_ext/array/wrap"
require "colorize"

module Quickruby
  class Test
    GLOB_PATTERN = "tests/**/test_*.rb"

    attr_reader :files, :test_cases, :assertions, :failures

    def initialize = @files = @test_cases = @assertions = @failures = 0

    def run(file = nil)
      @files = Array.wrap(file || Dir.glob(GLOB_PATTERN)).each { do_test_run(_1) }.size
      self
    end

    def summary
      "\n\n#{cnt(@files, "test file")}, " \
        "#{cnt(@test_cases, "test case")}, " \
        "#{cnt(@assertions, "assertion")}, " \
        "#{cnt(@failures, "failure")}"
    end

    private

    def cnt(num, word)= "#{num} #{word.pluralize(num)}"

    def do_test_run(file)
      pathname = Pathname.new(file)

      puts "Running #{pathname.basename}".colorize(:blue)
      test_run = TestFile.run(pathname.read) do |name, failure|
        kaller = failure.original_caller
        # puts kaller.join("\n").colorize(:red)
        warn "#{failure.message}, error in #{file}:#{kaller[0].split(":")[1]} in `test #{name}`"
      end

      @test_cases += test_run.test_cases.size
      @assertions += test_run.assertions
      @failures += test_run.failures
    end
  end
end
