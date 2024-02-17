# frozen_string_literal: true

module Core
  module Domain
    class InvalidIdError < Error
      # @param id [String]
      def initialize(id)
        @id = id
        super()
      end

      # @return [String]
      def error_code = "invalid_id"

      # @return [String]
      def error_message = "The id #{@id} is not valid"
    end
  end
end
