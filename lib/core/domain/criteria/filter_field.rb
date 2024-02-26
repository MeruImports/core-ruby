# frozen_string_literal: true

module Core
  module Domain
    class Criteria
      class FilterField
        # @return [String]
        attr_reader :value

        # @param value [String]
        def initialize(value)
          @value = value
          ensure_valid_field
        end

        private

        def ensure_valid_field
          raise ArgumentError, "Invalid field" if value.empty?
        end
      end
    end
  end
end
