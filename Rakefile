# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
end

require "standard/rake"

task :tests do
  exec("ruby app.rb tests")
end

task default: %i[tests]
