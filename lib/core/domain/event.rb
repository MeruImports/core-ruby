# frozen_string_literal: true

module Core
  module Domain
    class Event
      # @return [String]
      attr_reader :event_id

      # @return [Integer]
      attr_reader :occurred_at

      # @return [void]
      def initialize
        @event_id = ValueObject::UUID.random
        @occurred_at = Clock.unix_timestamp
      end

      # @return [String]
      def event_name = raise NotImplementedError

      # @return [Hash]
      def to_primitives = raise NotImplementedError

      # @return [Hash]
      def as_json = {data: to_primitives, event_id:, event_name:, occurred_at:}

      # @return [String]
      def to_json = as_json.to_json
    end
  end
end
