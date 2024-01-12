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
        require_relative "quickruby/test/test"

        print "Running tests..."

        test = Test.new.run ARGV[1]

        print "Success🎉".colorize(:green) if test.failures == 0

        puts test.summary

        exit 1 if test.failures > 0
      else
        if $0 == "app.rb"
          warn "Command not found: #{command}"

          exit 1
        end
      end
    else
      puts "Runnig app..."
    end
  end
end

Quickruby.run
