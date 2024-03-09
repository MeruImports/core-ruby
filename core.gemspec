# frozen_string_literal: true

require_relative "lib/core/version"

Gem::Specification.new do |spec|
  spec.name = "core"
  spec.version = Core::VERSION
  spec.authors = ["Alejandro Cen"]
  spec.email = ["alex96.cen@gmail.com"]
  spec.description = "Core classes for Meru"
  spec.summary = "Core classes for Meru"
  spec.files = Dir.glob("lib/**/*.rb")
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.2"

  spec.add_dependency "activesupport", "~> 7.1"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.add_development_dependency "rake", "~> 13.1"
  spec.add_development_dependency "byebug", "~> 11.1"
  spec.add_development_dependency "standard", "~> 1.33"
  spec.add_development_dependency "standard-performance", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "simplecov", "~> 0.22.0"
  spec.add_development_dependency "simplecov_json_formatter", "~> 0.1.4"
  spec.add_development_dependency "mongoid", "~> 8.1"
  spec.add_development_dependency "database_cleaner-mongoid", "~> 2.0"

  spec.metadata = {"rubygems_mfa_required" => "true"}
end
