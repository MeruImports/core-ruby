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

  context "with multiple filters" do
    let(:query) do
      {
        name__eq: "John",
        admin__ne: false,
        age__gt: 18,
        age__lt: 25,
        last_name__contains: "Do",
        permissions__in: "read,write",
        "address.zip_code__contains": "97"
      }
    end
    let(:order_by) { "name" }
    let(:order_type) { "asc" }
    let(:limit) { 10 }
    let(:offset) { 0 }
    let(:criteria) { Core::Domain::Criteria.from_values(query:, order_by:, order_type:, limit:, offset:) }
    let(:mongo_criteria) { described_class.new(criteria) }
    let(:docs) do
      UserMongoidDocument
        .where(mongo_criteria.filters)
        .order(mongo_criteria.order)
        .limit(mongo_criteria.limit)
        .offset(mongo_criteria.offset)
    end

    it "mongo criteria filters" do
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
    end

    it "mongo criteria order" do
      expect(mongo_criteria.order).to eq({"name" => "asc"})
    end

    it "mongo criteria limit" do
      expect(mongo_criteria.limit).to eq(10)
    end

    it "mongo criteria offset" do
      expect(mongo_criteria.offset).to eq(0)
    end

    it "return valid documents" do
      expect(docs.count).to eq(1)
    end
  end

  context "with gte and lte filters" do
    let(:query) {{age__gte: 20, age__lte: 25, permissions__nin: "update,delete"}}
    let(:order_by) { "name" }
    let(:order_type) { "asc" }
    let(:limit) { 10 }
    let(:offset) { 0 }
    let(:criteria) { Core::Domain::Criteria.from_values(query:, order_by:, order_type:, limit:, offset:) }
    let(:mongo_criteria) { described_class.new(criteria) }
    let(:docs) do
      UserMongoidDocument
        .where(mongo_criteria.filters)
        .order(mongo_criteria.order)
        .limit(mongo_criteria.limit)
        .offset(mongo_criteria.offset)
    end

    it "mongo criteria filters" do
      expect(mongo_criteria.filters).to eq(
        {"age" => {"$gte" => 20, "$lte" => 25}, "permissions" => {"$nin" => ["update", "delete"]}}
      )
    end

    it "return valid documents" do
      expect(docs.count).to eq(2)
    end
  end

  context "with search filter" do
    let(:query) { {"keywords__search" => "jo ja", "age__gte" => 18, "age__lte" => 25} }
    let(:criteria) { Core::Domain::Criteria.from_values(query:) }
    let(:mongo_criteria) { described_class.new(criteria) }
    let(:docs) do
      UserMongoidDocument
        .where(mongo_criteria.filters)
        .order(mongo_criteria.order)
        .limit(mongo_criteria.limit)
        .offset(mongo_criteria.offset)
    end

    it "mongo criteria filters" do
      expect(mongo_criteria.filters).to eq(
        {
          "$or" => [{"keywords" => /jo/i}, {"keywords" => /ja/i}],
          "age" => {"$gte" => 18, "$lte" => 25}
        }
      )
    end

    it "return valid documents" do
      expect(docs.count).to eq(2)
    end
  end

  context "with empty search filter" do
    let(:query) { {"keywords__search" => ""} }
    let(:criteria) { Core::Domain::Criteria.from_values(query:) }
    let(:mongo_criteria) { described_class.new(criteria) }
    let(:docs) do
      UserMongoidDocument
        .where(mongo_criteria.filters)
        .order(mongo_criteria.order)
        .limit(mongo_criteria.limit)
        .offset(mongo_criteria.offset)
    end

    it "mongo criteria filters" do
      expect(mongo_criteria.filters).to eq({})
    end

    it "return valid documents" do
      expect(docs.count).to eq(3)
    end
  end

  context "with nil search filter" do
    let(:query) { {"keywords__search" => nil} }
    let(:criteria) { Core::Domain::Criteria.from_values(query:) }
    let(:mongo_criteria) { described_class.new(criteria) }
    let(:docs) do
      UserMongoidDocument
        .where(mongo_criteria.filters)
        .order(mongo_criteria.order)
        .limit(mongo_criteria.limit)
        .offset(mongo_criteria.offset)
    end

    it "mongo criteria filters" do
      expect(mongo_criteria.filters).to eq({})
    end

    it "return valid documents" do
      expect(docs.count).to eq(3)
    end
  end

  context "with search filter with accent" do
    let(:query) { {"keywords__search" => "Ós"} }
    let(:criteria) { Core::Domain::Criteria.from_values(query:) }
    let(:mongo_criteria) { described_class.new(criteria) }
    let(:docs) do
      UserMongoidDocument
        .where(mongo_criteria.filters)
        .order(mongo_criteria.order)
        .limit(mongo_criteria.limit)
        .offset(mongo_criteria.offset)
    end

    it "mongo criteria filters" do
      expect(mongo_criteria.filters).to eq({"$or" => [{"keywords" => /os/i}]})
    end

    it "return valid documents" do
      expect(docs.count).to eq(1)
    end
  end

  context "with none criteria" do
    let(:criteria) { Core::Domain::Criteria.none }
    let(:mongo_criteria) { described_class.new(criteria) }
    let(:docs) do
      UserMongoidDocument
        .where(mongo_criteria.filters)
        .order(mongo_criteria.order)
        .limit(mongo_criteria.limit)
        .offset(mongo_criteria.offset)
    end

    it "mongo criteria filters" do
      expect(mongo_criteria.filters).to eq({})
    end

    it "return valid documents" do
      expect(docs.count).to eq(3)
    end
  end
end
