# frozen_string_literal: true

module Core
  module Domain
    module AggregateRoot
      # @param base [Class]
      def self.included(base) = base.private_class_method(:new)

      # @return [Array<Event>]
      def pull_domain_events
        events = domain_events.dup
        domain_events.clear
        events
      end

      # @param domain_event [Event]
      def record(domain_event) = domain_events << domain_event

      # @return [Array<Event>]
      def domain_events = @domain_events ||= []

      # @abstract
      # @return [Hash]
      def to_primitives = raise NotImplementedError

      # @param other [AggregateRoot]
      # @return [Boolean]
      def ==(other)
        self.class == other.class && to_primitives == other.to_primitives
      end
    end
  end
end
