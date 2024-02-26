# frozen_string_literal: true

require "simplecov_json_formatter"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [SimpleCov::Formatter::SimpleFormatter, SimpleCov::Formatter::JSONFormatter]
)

SimpleCov.profiles.define "profile" do
  track_files "src/**/*.rb"

  add_filter "test"
  add_filter "config"
end

SimpleCov.start "profile"
