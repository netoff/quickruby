# frozen_string_literal: true

require_relative "quickruby/version"

require_relative "quickruby/test"

module Quickruby
  # Do we need this?
  # class Error < StandardError; end

  def self.run
    command = ARGV[0]

    case command
    when 'test'
      Test.new.run
    when 'tests'
      STDERR.puts "Command not found: #{command}"

      exit 1
    end
  end
end

Quickruby.run if ARGV.size > 0
