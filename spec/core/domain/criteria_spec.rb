# frozen_string_literal: true

RSpec.describe Core::Domain::Criteria do
  it "with empty values" do
    criteria = described_class.from_values

    expect(criteria.filters.to_primitives).to eq([])
    expect(criteria.filters?).to eq(false)
    expect(criteria.order?).to eq(false)
    expect(criteria.limit).to eq(20)
    expect(criteria.offset).to eq(0)
  end

  it "with none described_class" do
    criteria = described_class.none

    expect(criteria.filters.to_primitives).to eq([])
    expect(criteria.filters?).to eq(false)
    expect(criteria.order?).to eq(false)
    expect(criteria.limit).to eq(nil)
    expect(criteria.offset).to eq(nil)
  end

  it "has values" do
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
    criteria = described_class.from_values(query:, order_by:, order_type:, limit:, offset:)

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
    expect(criteria.order?).to eq(true)
    expect(criteria.order.order_by).to eq("name")
    expect(criteria.order.order_type).to eq("asc")
    expect(criteria.limit).to eq(10)
    expect(criteria.offset).to eq(5)
  end

  it "has invalid filter operator" do
    query = {"address.zip_code__regex" => "97"}
    order_by = "name"
    order_type = "asc"
    limit = 10
    offset = 5

    expect {
      described_class.from_values(query:, order_by:, order_type:, limit:, offset:)
    }.to raise_error(Core::Domain::Criteria::InvalidFilterError)
  end

  it "has search filter" do
    query = {"keywords__search" => "John"}
    criteria = described_class.from_values(query:)
    expect(criteria.filters?).to eq(true)
    expect(criteria.filters.to_primitives).to eq([{field: "keywords", operator: "search", value: "John"}])
  end
end
