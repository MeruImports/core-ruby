# frozen_string_literal: true

module Core
  module Domain
    class Criteria
      class OrderType
        TYPES = [
          ASC = "asc",
          DESC = "desc",
          NONE = "none"
        ].freeze

        private_constant :TYPES

        # @return [String]
        attr_reader :value

        # @param value [String]
        def initialize(value)
          @value = value
          ensure_valid_order_type
        end

        # @return [Boolean]
        def none? = value.eql?(NONE)

        # @return [self]
        def self.none = new(NONE)

        private

        def ensure_valid_order_type
          raise ArgumentError, "Invalid order type" if TYPES.exclude?(@value)
        end
      end
    end
  end
end
