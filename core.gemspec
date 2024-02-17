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
  spec.metadata = {
    "rubygems_mfa_required" => "true"
  }
end
