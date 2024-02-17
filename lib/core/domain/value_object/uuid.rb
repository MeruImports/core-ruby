# frozen_string_literal: true

module Core
  module Domain
    module ValueObject
      class UUID
        # This regex checks whether a string conforms to the format of a UUID version 4.
        # @type [Regexp]
        REGEXP = /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i

        # @return [String]
        attr_reader :value

        # @param value [String]
        def initialize(value)
          @value = value
          ensure_is_valid_uuid
        end

        # @return [String]
        def self.random = new(SecureRandom.uuid).value

        private

        # @return [void]
        # @raise [InvalidIdError]
        def ensure_is_valid_uuid
          return if REGEXP.match?(@value)
          raise InvalidIdError, @value
        end
      end
    end
  end
end
