# frozen_string_literal: true

module Core
  module Domain
    module ValueObject
      class Integer
        # @param value [Integer]
        def initialize(value)
          @value = value
          ensure_valid_integer
        end

        # @return [Integer]
        attr_reader :value

        private

        def ensure_valid_integer
          raise InvalidIntegerError, self.class.name.demodulize unless @value.is_a?(::Integer)
        end
      end
    end
  end
end
