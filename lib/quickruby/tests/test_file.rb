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

    def self.run(code, filename = nil)
      filename ||= caller(1..1).first.split(":").first
      new.tap do |run|
        run.instance_eval(code, filename, 1)

        run.test_cases.each do |name, test|
          if (around = run.instance_variable_get(:@around))
            around.call proc { test.run_case }
          else
            test.run_case
          end

          yield(name, nil) if block_given?
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
      raise "tests `#{name}` already defined" if @test_cases[name]

      block.instance_exec(self) do |run|
        define_singleton_method(:assert) do |*args|
          original_caller = caller(1..1)

          if args.size == 1
            predicate = args.first
          elsif args.size == 2 && args.each { |arg| arg.is_a?(String) }
            original, expected = args
            unless (predicate = original.include?(expected))
              $stderr.puts "Expected #{original.inspect} to include #{expected.inspect}".colorize(:red)
            end
          else
            raise ArgumentError.new("unsupported arguments to `assert`")
          end

          run.assertions += 1
          raise Failure.new(original_caller) unless predicate
        end

        define_singleton_method(:run_case) do
          block.instance_eval(&block)
        rescue => e
          raise if e.is_a?(Failure)
          raise Failure.new(e.backtrace, e.message)
        end
      end

      @test_cases[name] = block
    end
  end
end
