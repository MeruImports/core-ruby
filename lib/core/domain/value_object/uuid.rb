# frozen_string_literal: true

module Core
  module Domain
    module ValueObject
      class UUID
        # This regexp checks whether a string conforms to the format of a UUID version 4.
        # @type [Regexp]
        UUID_V4_REGEXP = /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i

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
          raise InvalidIdError, @value unless UUID_V4_REGEXP.match?(@value)
        end
      end
    end
  end
end
