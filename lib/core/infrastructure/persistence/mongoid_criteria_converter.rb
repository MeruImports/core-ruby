# frozen_string_literal: true

module Core
  module Infrastructure
    module Persistence
      class MongoidCriteriaConverter
        FILTERS = {
          Domain::Criteria::FilterOperator::EQUAL => :equal_filter,
          Domain::Criteria::FilterOperator::NOT_EQUAL => :not_equal_filter,
          Domain::Criteria::FilterOperator::GT => :greater_than_filter,
          Domain::Criteria::FilterOperator::GTE => :greater_or_equal_than_filter,
          Domain::Criteria::FilterOperator::LT => :less_than_filter,
          Domain::Criteria::FilterOperator::LTE => :less_or_equal_than_filter,
          Domain::Criteria::FilterOperator::CONTAINS => :contains_filter,
          Domain::Criteria::FilterOperator::NOT_CONTAINS => :not_contains_filter,
          Domain::Criteria::FilterOperator::IN => :in_filter,
          Domain::Criteria::FilterOperator::NOT_IN => :not_in_filter,
          Domain::Criteria::FilterOperator::SEARCH => :search_filter
        }.freeze

        private_constant :FILTERS

        # @param criteria [Domain::Criteria]
        def initialize(criteria) = @criteria = criteria

        # @return [Hash]
        def filters
          @criteria.filters.filters.each_with_object({}) do |filter, criteria|
            criteria.deep_merge!(send(FILTERS[filter.operator], filter))
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
        # @return [Hash]
        def equal_filter(filter) = {filter.field => {"$eq" => filter.value}}

        # @param filter [Domain::Criteria::Filter]
        # @return [Hash]
        def not_equal_filter(filter) = {filter.field => {"$ne" => filter.value}}

        # @param filter [Domain::Criteria::Filter]
        # @return [Hash]
        def greater_than_filter(filter) = {filter.field => {"$gt" => filter.value}}

        # @param filter [Domain::Criteria::Filter]
        # @return [Hash]
        def greater_or_equal_than_filter(filter) = {filter.field => {"$gte" => filter.value}}

        # @param filter [Domain::Criteria::Filter]
        # @return [Hash]
        def less_than_filter(filter) = {filter.field => {"$lt" => filter.value}}

        # @param filter [Domain::Criteria::Filter]
        # @return [Hash]
        def less_or_equal_than_filter(filter) = {filter.field => {"$lte" => filter.value}}

        # @param filter [Domain::Criteria::Filter]
        # @return [Hash]
        def contains_filter(filter) = {filter.field => {"$regex" => filter.value}}

        # @param filter [Domain::Criteria::Filter]
        # @return [Hash]
        def not_contains_filter(filter) = {filter.field => {"$not" => {"$regex" => filter.value}}}

        # @param filter [Domain::Criteria::Filter]
        # @return [Hash]
        def in_filter(filter) = {filter.field => {"$in" => to_a(filter.value)}}

        # @param filter [Domain::Criteria::Filter]
        # @return [Hash]
        def not_in_filter(filter) = {filter.field => {"$nin" => to_a(filter.value)}}

        # @param filter [Domain::Criteria::Filter]
        # @return [Hash]
        def search_filter(filter)
          args = filter.value.split.map { |word| {filter.field => regexp(word)} }
          args.any? ? {"$or" => args} : {}
        end

        # @param str [String]
        # @return [Array<String>]
        def to_a(str) = str.split(",").map(&:strip)

        # @param value [String]
        # @return [Regexp]
        def regexp(value) = Regexp.new(Regexp.escape(value), Regexp::IGNORECASE)
      end
    end
  end
end
