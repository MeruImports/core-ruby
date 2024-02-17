# frozen_string_literal: true

require "active_support/all"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("uuid" => "UUID")
loader.setup

module Core
end
