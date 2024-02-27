# frozen_string_literal: true

module Core
  module Domain
    # Base error class for all domain errors
    # @example Define a new error
    #   # frozen_string_literal: true
    #
    #   class IdError < Core::Domain::Error
    #     # @param id [String]
    #     def initialize(id)
    #       @id = id
    #       super()
    #     end
    #
    #     # @return [String]
    #     def error_code = "invalid_id"
    #
    #     # @return [String]
    #     def error_message = "The id #{@id} is not valid"
    #   end
    #
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
