# frozen_string_literal: true

module Core
  module Domain
    class Error < StandardError
      def initialize = super(error_message)

      # @abstract
      # @return [String]
      def error_code = raise NotImplementedError

      # @abstract
      # @return [String]
      def error_message = raise NotImplementedError
    end
  end
end
