# frozen_string_literal: true

module Core
  module Infrastructure
    module Persistence
      class MongoidCriteriaConverterTest < Minitest::Test
        def setup
          UserMongoidDocument.create!(
            [
              {name: "John", admin: true, age: 20, last_name: "Doe"},
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
            "last_name__contains" => "Do"
          }
          order_by = "name"
          order_type = "asc"
          limit = 10
          offset = 0
          criteria = Domain::Criteria.from_values(filters, order_by, order_type, limit, offset)
          mongo_criteria = MongoidCriteriaConverter.new(criteria)
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
