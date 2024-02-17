# frozen_string_literal: true

module Core
  module Domain
    class Clock
      # @return [Integer]
      def self.unix_timestamp = Time.current.utc.to_i
    end
  end
end
