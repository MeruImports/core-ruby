# frozen_string_literal: true

module Core
  module Domain
    class Tokenizer
      # @type [Regexp]
      PARSER_REGEX = /([A-GJXa-gjx]#|\$?[0-9.]+|[a-zA-Z&_0-9]+('s)?\+*|[\-.!@%^*()\[\]\={"'\\}|:;<,>?\/~`\$#+])/

      private_constant :PARSER_REGEX

      # @param phrases [Array<String>]
      def initialize(phrases) = @phrases = phrases

      # @param phrases [Array<String>]
      # @return [Array<String>]
      def parse = @phrases.flat_map(&method(:tokenize))

      # @param phrases [Array<String>]
      # @return [Array<String>]
      def self.parse(phrases) = new(phrases).parse

      # @param phrase [String]
      # @return [String]
      def self.sanitize(phrase) = ActiveSupport::Inflector.transliterate(phrase.to_s.downcase)

      private

      # @param phrase [String]
      # @return [Array<String>]
      def tokenize(phrase) = Tokenizer.sanitize(phrase).scan(PARSER_REGEX).map(&:first)
    end
  end
end
