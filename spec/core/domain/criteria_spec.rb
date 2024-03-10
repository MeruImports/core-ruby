# frozen_string_literal: true

RSpec.describe Core::Domain::Criteria do
  context "with empty values criteria" do
    let(:criteria) { described_class.from_values }

    it "has no filters" do
      expect(criteria.filters.to_primitives).to eq([])
      expect(criteria.filters?).to eq(false)
    end

    it "has no order" do
      expect(criteria.order?).to eq(false)
    end

    it "has default limit" do
      expect(criteria.limit).to eq(20)
    end

    it "has default offset" do
      expect(criteria.offset).to eq(0)
    end
  end

  context "with none criteria" do
    let(:criteria) { described_class.none }

    it "has no filters" do
      expect(criteria.filters.to_primitives).to eq([])
      expect(criteria.filters?).to eq(false)
    end

    it "has no order" do
      expect(criteria.order?).to eq(false)
    end

    it "has no limit" do
      expect(criteria.limit).to eq(nil)
    end

    it "has no offset" do
      expect(criteria.offset).to eq(nil)
    end
  end

  context "criteria with values" do
    let(:query) do
      {
        name__eq: "John",
        admin__ne: false,
        age__gt: 18,
        age__lt: 30,
        last_name__contains: "Doe",
        permissions__in: "read,write",
        "address.zip_code__not_contains": "97"
      }
    end
    let(:order_by) { "name" }
    let(:order_type) { "asc" }
    let(:limit) { 10 }
    let(:offset) { 5 }
    let(:criteria) { described_class.from_values(query:, order_by:, order_type:, limit:, offset:) }

    it "has filters" do
      expect(criteria.filters?).to eq(true)
      expect(criteria.filters.to_primitives).to eq([
        {field: "name", operator: "eq", value: "John"},
        {field: "admin", operator: "ne", value: false},
        {field: "age", operator: "gt", value: 18},
        {field: "age", operator: "lt", value: 30},
        {field: "last_name", operator: "contains", value: "Doe"},
        {field: "permissions", operator: "in", value: "read,write"},
        {field: "address.zip_code", operator: "not_contains", value: "97"}
      ])
    end

    it "has order" do
      expect(criteria.order?).to eq(true)
      expect(criteria.order.order_by).to eq("name")
      expect(criteria.order.order_type).to eq("asc")
    end

    it "has limit" do
      expect(criteria.limit).to eq(10)
    end

    it "has offset" do
      expect(criteria.offset).to eq(5)
    end
  end

  context "criteria with invalid filter operator" do
    let(:query) { {"address.zip_code__regex" => "97"} }
    let(:order_by) { "name" }
    let(:order_type) { "asc" }
    let(:limit) { 10 }
    let(:offset) { 5 }
    let(:criteria) { described_class.from_values(query:, order_by:, order_type:, limit:, offset:) }

    it "raise invalid filter error" do
      expect {
        described_class.from_values(query:, order_by:, order_type:, limit:, offset:)
      }.to raise_error(Core::Domain::Criteria::InvalidFilterError)
    end
  end

  context "criteria with search filter" do
    let(:query) { {"keywords__search" => "John"} }
    let(:criteria) { described_class.from_values(query:) }

    it "has search filter" do
      expect(criteria.filters?).to eq(true) 
      expect(criteria.filters.to_primitives).to eq([{field: "keywords", operator: "search", value: "John"}])
    end
  end
end
