# frozen_string_literal: true

module Core
  module Domain
    class Criteria
      class Filters
        # @return [Array<Filter>]
        attr_reader :filters

        # @param filters [Array<Filter>]
        def initialize(filters) = @filters = filters

        # @return [Boolean]
        def any? = filters.any?

        # @return [Array<Hash>]
        def to_primitives = filters.map(&:to_primitives)

        # @param values [Hash]
        # @return [self]
        def self.from_values(values)
          new(values.map { |predicate, value| Filter.from_values(predicate.to_s, value) })
        end

        # @return [self]
        def self.none = new([])
      end
    end
  end
end
