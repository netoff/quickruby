module Quickruby
  class TestFile
    Failure = Class.new(StandardError) do
      attr_reader :original_caller

      def initialize(original_caller, message = "Assertion failed")
        @original_caller = original_caller
        super message
      end
    end

    attr_accessor :test_cases, :assertions, :failures

    def self.run(code)
      new.tap do |run|
        run.instance_eval(code)

        run.test_cases.each do |name, test|
          if (a = run.instance_variable_get(:@around))
            a.call proc { test.run_case }
          else
            test.run_case
          end
        rescue Failure => e
          run.failures += 1
          yield(name, e) if block_given?
        end
      end
    end

    def initialize
      @test_cases = {}
      @assertions = @failures = 0
    end

    def around(&block)
      raise "around already defined" if @around

      @around = block
    end

    def test(name, &block)
      raise "test `#{name}` already defined" if @test_cases[name]

      block.instance_exec(self) do |run|
        define_singleton_method(:assert) do |predicate|
          run.assertions += 1
          unless predicate
            raise Failure.new(caller)
          end
        end

        define_singleton_method(:run_case) do
          block.instance_eval(&block)
        rescue => e
          raise if e.is_a?(Failure)

          run.failures += 1
          raise Failure.new(caller)
        end
      end

      @test_cases[name] = block
    end
  end
end
