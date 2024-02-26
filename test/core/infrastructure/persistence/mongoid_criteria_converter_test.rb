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
                address_attributes: {zip_code: "97000"}
              },
              {name: "Jane", admin: false, age: 25, last_name: "Doe"}
            ]
          )
        end

        def test_filters
          filters = {
            "name__equal" => "John",
            "admin__not_equal" => false,
            "age__gt" => 18,
            "age__lt" => 25,
            "last_name__contains" => "Do",
            "address.zip_code__contains" => "97"
          }
          order_by = "name"
          order_type = "asc"
          limit = 10
          offset = 0
          criteria = Domain::Criteria.from_values(filters, order_by, order_type, limit, offset)
          mongo_criteria = MongoidCriteriaConverter.new(criteria)
          assert_equal(
            {
              "name" => {"$eq" => "John"},
              "admin" => {"$ne" => false},
              "age" => {"$gt" => 18, "$lt" => 25},
              "last_name" => {"$regex" => "Do"},
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
      end
    end
  end
end
