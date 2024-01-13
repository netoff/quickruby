require_relative "test_file"
require_relative 'helpers'

require "active_support/inflector"
require "active_support/core_ext/array/wrap"
require "active_support/core_ext/string/filters.rb"
require "colorize"

module Quickruby
  class Tests
    GLOB_PATTERN = "tests/**/test_*.rb"

    attr_reader :files, :test_cases, :assertions, :failures

    def initialize = @files = @test_cases = @assertions = @failures = 0

    def run(file = nil)
      @files = Array.wrap(file || Dir.glob(GLOB_PATTERN)).each { do_test_run(_1) }.size
      self
    end

    def summary
      "\n\n#{cnt(@files, "tests file")}, " \
        "#{cnt(@test_cases, "tests case")}, " \
        "#{cnt(@assertions, "assertion")}, " \
        "#{cnt(@failures, "failure")}"
    end

    private

    def cnt(num, word)= "#{num} #{word.pluralize(num)}"

    def do_test_run(file)
      pathname = Pathname.new(file)

      # print pathname.basename.to_s.colorize(:blue)

      test_run = TestFile.run(pathname.read, pathname.to_s) do |name, failure|
        if failure
          kaller = failure.original_caller
          file, line = kaller[0].split(":")
          $stderr.puts "#{failure.message}, error in #{file}:#{line} in `tests #{name}`"
        else
          print ".".colorize(:green)
        end
      end

      @test_cases += test_run.test_cases.size
      @assertions += test_run.assertions
      @failures += test_run.failures
    end
  end
end
