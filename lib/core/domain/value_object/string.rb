# frozen_string_literal: true

module Core
  module Domain
    module ValueObject
      class String
        # @param value [String]
        def initialize(value, name, message)
          @value = value
          ensure_valid_string(name, message)
        end

        # @return [String]
        attr_reader :value

        private

        def ensure_valid_string(name, message)
          raise InvalidStringError, {name:, message:} if @value.strip.empty?
        end
      end
    end
  end
end
