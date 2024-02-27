# frozen_string_literal: true

module Core
  module Domain
    class Criteria
      class FilterOperator
        OPERATORS = [
          EQUAL = "eq",
          NOT_EQUAL = "ne",
          GT = "gt",
          GTE = "gte",
          LT = "lt",
          LTE = "lte",
          CONTAINS = "contains",
          NOT_CONTAINS = "not_contains",
          IN = "in",
          NOT_IN = "nin"
        ].freeze

        private_constant :OPERATORS

        # @return [String]
        attr_reader :value

        def initialize(value)
          @value = value
          ensure_valid_operator
        end

        private

        def ensure_valid_operator
          raise InvalidFilterError, @value if OPERATORS.exclude?(@value)
        end
      end
    end
  end
end
