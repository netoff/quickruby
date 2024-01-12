# frozen_string_literal: true

require_relative "quickruby/version"

module Quickruby
  # Do we need this?
  # class Error < StandardError; end

  def self.run
    if ARGV.size > 0
      command = ARGV[0]

      case command
      when "tests"
        require_relative "quickruby/tests/tests"

        print "Running tests...\n"

        tests = Tests.new.run ARGV[1]

        print "Success🎉".colorize(:green) if tests.failures == 0

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

Quickruby.run
