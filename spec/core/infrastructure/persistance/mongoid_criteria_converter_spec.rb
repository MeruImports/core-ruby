# frozen_string_literal: true

RSpec.describe Core::Infrastructure::Persistence::MongoidCriteriaConverter do
  before do
    UserMongoidDocument.create!(
      [
        {
          name: "John",
          admin: true,
          age: 20,
          last_name: "Doe",
          permissions: ["read", "write"],
          keywords: Core::Domain::Tokenizer.parse(["John", "Doe"]),
          address_attributes: {zip_code: "97000"}
        },
        {name: "Jane", admin: false, age: 25, last_name: "Doe", keywords: Core::Domain::Tokenizer.parse(["Jane", "Doe"])},
        {name: "Óscar", admin: false, age: 40, last_name: "Doe", keywords: Core::Domain::Tokenizer.parse(["Óscar", "Doe"])}
      ]
    )
  end

  it "filters" do
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
    criteria = Core::Domain::Criteria.from_values(query:, order_by:, order_type:, limit:, offset:)
    mongo_criteria = described_class.new(criteria)
    expect(mongo_criteria.filters).to eq(
      {
        "name" => {"$eq" => "John"},
        "admin" => {"$ne" => false},
        "age" => {"$gt" => 18, "$lt" => 25},
        "last_name" => {"$regex" => "Do"},
        "permissions" => {"$in" => ["read", "write"]},
        "address.zip_code" => {"$regex" => "97"}
      }
    )
    expect(mongo_criteria.order).to eq({"name" => "asc"})
    expect(mongo_criteria.limit).to eq(10)
    expect(mongo_criteria.offset).to eq(0)
    docs = UserMongoidDocument
      .where(mongo_criteria.filters)
      .order(mongo_criteria.order)
      .limit(mongo_criteria.limit)
      .offset(mongo_criteria.offset)
    expect(docs.count).to eq(1)
  end

  it "gte_and_lte_filter" do
    query = {age__gte: 20, age__lte: 25, permissions__nin: "update,delete"}
    order_by = "name"
    order_type = "asc"
    limit = 10
    offset = 0
    criteria = Core::Domain::Criteria.from_values(query:, order_by:, order_type:, limit:, offset:)
    mongo_criteria = described_class.new(criteria)
    expect(mongo_criteria.filters).to eq(
      {"age" => {"$gte" => 20, "$lte" => 25}, "permissions" => {"$nin" => ["update", "delete"]}}
    )
    docs = UserMongoidDocument
      .where(mongo_criteria.filters)
      .order(mongo_criteria.order)
      .limit(mongo_criteria.limit)
      .offset(mongo_criteria.offset)
    expect(docs.count).to eq(2)
  end

  it "search_filter" do
    query = {"keywords__search" => "jo ja", "age__gte" => 18, "age__lte" => 25}
    criteria = Core::Domain::Criteria.from_values(query:)
    mongo_criteria = described_class.new(criteria)
    expect(mongo_criteria.filters).to eq(
      {
        "$or" => [{"keywords" => /jo/i}, {"keywords" => /ja/i}],
        "age" => {"$gte" => 18, "$lte" => 25}
      }
    )
    docs = UserMongoidDocument
      .where(mongo_criteria.filters)
      .order(mongo_criteria.order)
      .limit(mongo_criteria.limit)
      .offset(mongo_criteria.offset)
    expect(docs.count).to eq(2)
  end

  it "empty_search_filter" do
    query = {"keywords__search" => ""}
    criteria = Core::Domain::Criteria.from_values(query:)
    mongo_criteria = described_class.new(criteria)
    expect(mongo_criteria.filters).to eq({})
    docs = UserMongoidDocument
      .where(mongo_criteria.filters)
      .order(mongo_criteria.order)
      .limit(mongo_criteria.limit)
      .offset(mongo_criteria.offset)
    expect(docs.count).to eq(3)
  end

  it "nil_search_filter" do
    query = {"keywords__search" => nil}
    criteria = Core::Domain::Criteria.from_values(query:)
    mongo_criteria = described_class.new(criteria)
    expect(mongo_criteria.filters).to eq({})
    docs = UserMongoidDocument
      .where(mongo_criteria.filters)
      .order(mongo_criteria.order)
      .limit(mongo_criteria.limit)
      .offset(mongo_criteria.offset)
    expect(docs.count).to eq(3)
  end

  it "search_filter_with_accent" do
    query = {"keywords__search" => "Ós"}
    criteria = Core::Domain::Criteria.from_values(query:)
    mongo_criteria = described_class.new(criteria)
    expect(mongo_criteria.filters).to eq({"$or" => [{"keywords" => /os/i}]})
    docs = UserMongoidDocument
      .where(mongo_criteria.filters)
      .order(mongo_criteria.order)
      .limit(mongo_criteria.limit)
      .offset(mongo_criteria.offset)
    expect(docs.count).to eq(1)
  end

  it "return all documents with none criteria" do
    criteria = Core::Domain::Criteria.none
    mongo_criteria = described_class.new(criteria)
    expect(mongo_criteria.filters).to eq({})
    docs = UserMongoidDocument
      .where(mongo_criteria.filters)
      .order(mongo_criteria.order)
      .limit(mongo_criteria.limit)
      .offset(mongo_criteria.offset)
    expect(docs.count).to eq(3)
  end
end
