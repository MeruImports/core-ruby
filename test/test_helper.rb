# frozen_string_literal: true

ENV["RACK_ENV"] ||= "test"

require "byebug"
require "mongoid"
require "simplecov"
require "database_cleaner-mongoid"

require_relative "../lib/core"

Mongoid.load!("test/mongoid.yml")

class MongoidDocumentTest
  include Mongoid::Document

  field :name, type: String
  field :admin, type: Boolean
  field :age, type: Integer
  field :last_name, type: String
end

Minitest::Test.class_eval do
  def setup = DatabaseCleaner.start

  def teardown = DatabaseCleaner.clean
end