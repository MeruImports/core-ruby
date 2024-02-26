# frozen_string_literal: true

module Core
  module Infrastructure
    module Persistence
      class MongoidCriteriaConverter
        FILTERS = {
          Domain::Criteria::FilterOperator::EQUAL => :equal_filter,
          Domain::Criteria::FilterOperator::NOT_EQUAL => :not_equal_filter,
          Domain::Criteria::FilterOperator::GT => :greater_than_filter,
          Domain::Criteria::FilterOperator::LT => :less_than_filter,
          Domain::Criteria::FilterOperator::CONTAINS => :contains_filter,
          Domain::Criteria::FilterOperator::NOT_CONTAINS => :not_contains_filter
        }.freeze

        # @param criteria [Domain::Criteria]
        def initialize(criteria) = @criteria = criteria

        # @return [Hash]
        def filters
          @criteria.filters.filters.each_with_object({}) do |filter, criteria|
            criteria[filter.field] ||= {}
            criteria[filter.field].merge!(send(FILTERS[filter.operator], filter))
          end
        end

        # @return [Hash, nil]
        def order
          {@criteria.order.order_by => @criteria.order.order_type} if @criteria.order?
        end

        # @return [Integer]
        def limit = @criteria.limit

        # @return [Integer]
        def offset = @criteria.offset

        private

        # @param filter [Domain::Criteria::Filter]
        def equal_filter(filter) = {"$eq" => filter.value}

        # @param filter [Domain::Criteria::Filter]
        def not_equal_filter(filter) = {"$ne" => filter.value}

        # @param filter [Domain::Criteria::Filter]
        def greater_than_filter(filter) = {"$gt" => filter.value}

        # @param filter [Domain::Criteria::Filter]
        def less_than_filter(filter) = {"$lt" => filter.value}

        # @param filter [Domain::Criteria::Filter]
        def contains_filter(filter) = {"$regex" => filter.value}

        # @param filter [Domain::Criteria::Filter]
        def not_contains_filter(filter) = {"$not" => {"$regex" => filter.value}}
      end
    end
  end
end
