# frozen_string_literal: true

module Core
  module Domain
    class Criteria
      class InvalidFilterError < Error
        # @param value [String]
        def initialize(value)
          @value = value
          super()
        end

        # @return [String]
        def error_code = "invalid_filter"

        # @return [String]
        def error_message = "The filter #{@value} is not valid"
      end
    end
  end
end
