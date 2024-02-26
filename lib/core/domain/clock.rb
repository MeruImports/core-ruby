# frozen_string_literal: true

module Core
  module Domain
    class Clock
      # @return [Integer]
      def self.unix_timestamp = Time.current.utc.to_i

      # @param timestamp [Integer]
      # @return [Time]
      def self.from_unix_timestamp(timestamp, time_zone = nil)
        Time.at(timestamp).utc.in_time_zone(time_zone)
      end
    end
  end
end
