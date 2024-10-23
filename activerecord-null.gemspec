# frozen_string_literal: true

require_relative "lib/activerecord/null/version"

Gem::Specification.new do |spec|
  spec.name = "activerecord-null"
  spec.version = ActiveRecord::Null::VERSION
  spec.authors = ["Jim Gay"]
  spec.email = ["jim@saturnflyer.com"]

  spec.summary = "Null Objects for ActiveRecord"
  spec.description = "Create Null Objects for ActiveRecord models with automatic support for empty associations."
  spec.homepage = "https://github.com/SOFware/activerecord-null"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{lib,test}/**/*", "Rakefile", "README.md", "LICENSE.txt", "CHANGELOG.md"]
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 7.0"
end
