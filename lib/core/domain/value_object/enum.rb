# frozen_string_literal: true

module Core
  module Domain
    module ValueObject
      class Enum
        VALUES = [].freeze

        def initialize(value)
          @value = value
          ensure_valid_value
        end

        private

        def ensure_valid_value
          return if self.class::VALUES.include?(@value)

          raise InvalidEnumError, self.class.name.demodulize
        end
      end
    end
  end
end
