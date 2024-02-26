# frozen_string_literal: true

module Core
  module Domain
    class Criteria
      class Filter
        DELIMITER = "__"

        private_constant :DELIMITER

        # @param field [FilterField]
        # @param operator [FilterOperator]
        # @param value [FilterValue]
        def initialize(field, operator, value)
          @field = field
          @operator = operator
          @value = value
        end

        # @return [String]
        def field = @field.value

        # @return [String]
        def operator = @operator.value

        # @return [String]
        def value = @value.value

        # @return [Hash]
        def to_primitives = {field: @field.value, operator: @operator.value, value: @value.value}

        # @param predicate [String]
        # @param value [String]
        def self.from_values(predicate, value)
          field, operator = predicate.split(DELIMITER)
          new(FilterField.new(field), FilterOperator.new(operator), FilterValue.new(value))
        end
      end
    end
  end
end
