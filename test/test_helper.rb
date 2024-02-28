# frozen_string_literal: true

ENV["RACK_ENV"] ||= "test"

require "byebug"
require "mongoid"
require "simplecov"
require "database_cleaner-mongoid"

require_relative "../lib/core"

Mongoid.load!("test/mongoid.yml")

class AddressMongoidDocument
  include Mongoid::Document

  field :zip_code, type: String
end

class UserMongoidDocument
  include Mongoid::Document

  field :name, type: String
  field :admin, type: Boolean
  field :age, type: Integer
  field :last_name, type: String
  field :permissions, type: Array
  field :keywords, type: Array
  embeds_one :address, class_name: "AddressMongoidDocument"

  accepts_nested_attributes_for :address

  index({keywords: "text"})
end

UserMongoidDocument.create_indexes

Minitest::Test.class_eval do
  def setup = DatabaseCleaner.start

  def teardown = DatabaseCleaner.clean
end
