# frozen_string_literal: true

require "simplecov_json_formatter"

SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter

SimpleCov.profiles.define "profile" do
  track_files "lib/**/*.rb"

  add_filter "spec"
  add_filter "lib/core.rb"
  add_filter "config"
end

SimpleCov.start "profile"
