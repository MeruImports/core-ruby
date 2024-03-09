# frozen_string_literal: true

module Core
  module Domain
    class Criteria
      class Order
        # @param order_by [OrderBy]
        # @param order_type [OrderType]
        def initialize(order_by, order_type)
          @order_by = order_by
          @order_type = order_type
        end

        # @return [String]
        def order_by = @order_by.value

        # @return [String]
        def order_type = @order_type.value

        # @param order_by [String]
        # @param order_type [String]
        # @return [self]
        def self.from_values(order_by, order_type)
          new(OrderBy.new(order_by), OrderType.new(order_type || OrderType::NONE))
        end

        def self.none = new(OrderBy.none, OrderType.none)

        # @return [Boolean]
        def none? = @order_type.none?
      end
    end
  end
end
