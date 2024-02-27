# frozen_string_literal: true

module Core
  module Infrastructure
    module Persistence
      class MongoidCriteriaConverterTest < Minitest::Test
        def setup
          UserMongoidDocument.create!(
            [
              {
                name: "John",
                admin: true,
                age: 20,
                last_name: "Doe",
                permissions: ["read", "write"],
                keywords: ["Jonh", "Doe"],
                address_attributes: {zip_code: "97000"}
              },
              {name: "Jane", admin: false, age: 25, last_name: "Doe", keywords: ["Jane", "Doe"]},
              {name: "Óscar", admin: false, age: 40, last_name: "Doe", keywords: ["Óscar", "Doe"]}
            ]
          )
        end

        def test_filters
          query = {
            name__eq: "John",
            admin__ne: false,
            age__gt: 18,
            age__lt: 25,
            last_name__contains: "Do",
            permissions__in: "read,write",
            "address.zip_code__contains": "97"
          }
          order_by = "name"
          order_type = "asc"
          limit = 10
          offset = 0
          criteria = Domain::Criteria.from_values(query:, order_by:, order_type:, limit:, offset:)
          mongo_criteria = MongoidCriteriaConverter.new(criteria)
          assert_equal(
            {
              "name" => {"$eq" => "John"},
              "admin" => {"$ne" => false},
              "age" => {"$gt" => 18, "$lt" => 25},
              "last_name" => {"$regex" => "Do"},
              "permissions" => {"$in" => ["read", "write"]},
              "address.zip_code" => {"$regex" => "97"}
            },
            mongo_criteria.filters
          )
          assert_equal({"name" => "asc"}, mongo_criteria.order)
          assert_equal 10, mongo_criteria.limit
          assert_equal 0, mongo_criteria.offset
          docs = UserMongoidDocument
            .where(mongo_criteria.filters)
            .order(mongo_criteria.order)
            .limit(mongo_criteria.limit)
            .offset(mongo_criteria.offset)
          assert_equal 1, docs.count
        end

        def test_gte_and_lte_filter
          query = {age__gte: 20, age__lte: 25, permissions__nin: "update,delete"}
          order_by = "name"
          order_type = "asc"
          limit = 10
          offset = 0
          criteria = Domain::Criteria.from_values(query:, order_by:, order_type:, limit:, offset:)
          mongo_criteria = MongoidCriteriaConverter.new(criteria)
          assert_equal(
            {"age" => {"$gte" => 20, "$lte" => 25}, "permissions" => {"$nin" => ["update", "delete"]}},
            mongo_criteria.filters
          )
          docs = UserMongoidDocument
            .where(mongo_criteria.filters)
            .order(mongo_criteria.order)
            .limit(mongo_criteria.limit)
            .offset(mongo_criteria.offset)
          assert_equal 2, docs.count
        end

        def test_search_filter
          query = {"keywords__search" => "jo ja", "age__gte" => 18, "age__lte" => 25}
          criteria = Domain::Criteria.from_values(query:)
          mongo_criteria = MongoidCriteriaConverter.new(criteria)
          assert_equal(
            {
              "$or" => [{"keywords" => /jo/i}, {"keywords" => /ja/i}],
              "age" => {"$gte" => 18, "$lte" => 25}
            },
            mongo_criteria.filters
          )
          docs = UserMongoidDocument
            .where(mongo_criteria.filters)
            .order(mongo_criteria.order)
            .limit(mongo_criteria.limit)
            .offset(mongo_criteria.offset)
          assert_equal 2, docs.count
        end

        def test_empty_search_filter
          query = {"keywords__search" => ""}
          criteria = Domain::Criteria.from_values(query:)
          mongo_criteria = MongoidCriteriaConverter.new(criteria)
          assert_equal({}, mongo_criteria.filters)
          docs = UserMongoidDocument
            .where(mongo_criteria.filters)
            .order(mongo_criteria.order)
            .limit(mongo_criteria.limit)
            .offset(mongo_criteria.offset)
          assert_equal 3, docs.count
        end

        def test_search_filter_with_accent
          query = {"keywords__search" => "Ós"}
          criteria = Domain::Criteria.from_values(query:)
          mongo_criteria = MongoidCriteriaConverter.new(criteria)
          assert_equal({"$or" => [{"keywords" => /Ós/i}]}, mongo_criteria.filters)
          docs = UserMongoidDocument
            .where(mongo_criteria.filters)
            .order(mongo_criteria.order)
            .limit(mongo_criteria.limit)
            .offset(mongo_criteria.offset)
          assert_equal 1, docs.count
        end
      end
    end
  end
end
