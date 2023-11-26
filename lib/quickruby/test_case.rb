module Quickruby
  class TestCase
    Failure = Class.new(StandardError) do
      attr_reader :caller
      def initialize(caller)
        @caller = caller
        super("Assertion failed")
      end
    end

    attr_reader :block, :assertions

    def initialize(&block)
      @block = block
      @assertions = 0
    end

    def assert(predicate)
      @assertions += 1
      raise Failure.new(caller) unless predicate
    end

    def call
      instance_eval(&block)
    end
  end
end
