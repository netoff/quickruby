# frozen_string_literal: true

require_relative "lib/quickruby/version"

Gem::Specification.new do |spec|
  spec.name = "quickruby"
  spec.version = Quickruby::VERSION
  spec.authors = ["Dusan Pantelic aka netoff"]
  spec.email = ["netoff_@outlook.com"]

  spec.summary = "Hyperproductivity web framework for Ruby."
  spec.description = "Speed of light web development. Nothing unnecessary, bare minimum only."
  spec.homepage = "https://quickruby.dev"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/netoff/quickruby"
  spec.metadata["changelog_uri"] = "https://github.com/netoff/quickruby/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ tests/ dummy/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "activesupport", "~> 7.1"
  spec.add_dependency "colorize"

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "standard", "~> 1.3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
