require_relative './test_case.rb'

module Quickruby
  class TestFile
    attr_accessor :test_cases, :assertions, :failures

    def self.run(code)
      run = self.new

      run.instance_eval(code)
      run.test_cases.each do |name, test_case|
        begin
          test_case.call
        rescue TestCase::Failure => f
          # STDERR.puts "Assertion failed, error in #{file}:#{f.caller[0].split(':')[1]} in `tests #{f.name}`"
          run.failures = run.failures + 1
          yield(name, f) if block_given?
        end

        run.assertions = run.assertions + test_case.assertions
      end

      run
    end
    def initialize
      @test_cases = {}
      @assertions = @failures = 0
    end

    def test(name, &block)
      raise "test `#{name}` already defined" if @test_cases[name]
      @test_cases[name] = TestCase.new(&block)
    end
  end
end