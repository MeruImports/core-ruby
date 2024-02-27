# frozen_string_literal: true

module Core
  module Domain
    class CriteriaTest < Minitest::Test
      def test_empty_values
        criteria = Criteria.from_values

        assert_equal [], criteria.filters.to_primitives
        assert_equal false, criteria.filters?
        assert_equal false, criteria.order?
        assert_equal 20, criteria.limit
        assert_equal 0, criteria.offset
      end

      def test_with_values
        query = {
          name__eq: "John",
          admin__ne: false,
          age__gt: 18,
          age__lt: 30,
          last_name__contains: "Doe",
          permissions__in: "read,write",
          "address.zip_code__not_contains": "97"
        }
        order_by = "name"
        order_type = "asc"
        limit = 10
        offset = 5

        criteria = Criteria.from_values(query:, order_by:, order_type:, limit:, offset:)
        assert_equal true, criteria.filters?
        assert_equal [
          {field: "name", operator: "eq", value: "John"},
          {field: "admin", operator: "ne", value: false},
          {field: "age", operator: "gt", value: 18},
          {field: "age", operator: "lt", value: 30},
          {field: "last_name", operator: "contains", value: "Doe"},
          {field: "permissions", operator: "in", value: "read,write"},
          {field: "address.zip_code", operator: "not_contains", value: "97"}
        ], criteria.filters.to_primitives
        assert_equal true, criteria.order?
        assert_equal "name", criteria.order.order_by
        assert_equal "asc", criteria.order.order_type
        assert_equal 10, criteria.limit
        assert_equal 5, criteria.offset
      end

      def test_invalid_filter_operator
        query = {"address.zip_code__regex" => "97"}
        order_by = "name"
        order_type = "asc"
        limit = 10
        offset = 5

        assert_raises Criteria::InvalidFilterError do
          Criteria.from_values(query:, order_by:, order_type:, limit:, offset:)
        end
      end

      def test_search_filter
        query = {"keywords__search" => "John"}
        criteria = Criteria.from_values(query:)
        assert_equal true, criteria.filters?
        assert_equal [{field: "keywords", operator: "search", value: "John"}], criteria.filters.to_primitives
      end
    end
  end
end
