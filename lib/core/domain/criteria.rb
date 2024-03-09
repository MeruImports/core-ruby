# frozen_string_literal: true

module Core
  module Domain
    class Criteria
      # @return [Filters]
      attr_reader :filters

      # @return [Order]
      attr_reader :order

      # @return [Integer]
      attr_reader :limit

      # @return [Integer]
      attr_reader :offset

      # @param filters [Filters]
      # @param order [Order]
      # @param limit [Integer]
      # @param offset [Integer]
      def initialize(filters, order, limit, offset)
        @filters = filters
        @order = order
        @limit = limit
        @offset = offset
      end

      # @return [Boolean]
      def filters? = @filters.any?

      # @return [Boolean]
      def order? = !@order.none?

      def self.none = new(Filters.none, Order.none, nil, nil)

      # @param query [Hash, nil]
      # @param order_by [String, nil]
      # @param order_type [String, nil]
      # @param limit [Integer, nil]
      # @param offset [Integer, nil]
      # @return [self]
      def self.from_values(query: nil, order_by: nil, order_type: nil, limit: nil, offset: nil)
        new(
          Filters.from_values(query || {}),
          Order.from_values(order_by, order_type),
          limit || 20,
          offset || 0
        )
      end
    end
  end
end
