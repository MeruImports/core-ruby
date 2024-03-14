# frozen_string_literal: true

module Core
  module Domain
    module ValueObject
      class String
        # @param value [String]
        def initialize(value)
          @value = value
          ensure_valid_string
        end

        # @return [String]
        attr_reader :value

        private

        def ensure_valid_string
          raise InvalidStringError, self.class.name.demodulize if @value.strip.empty?
        end
      end
    end
  end
end
