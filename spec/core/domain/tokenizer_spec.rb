# frozen_string_literal: true

RSpec.describe Core::Domain::Tokenizer do
  context "with empty values" do
    let(:keywords) { described_class.parse([]) }

    it "returns an empty array" do
      expect(keywords).to eq([])
    end
  end

  context "with blank values" do
    let(:keywords) { described_class.parse([nil, "", " "]) }

    it "returns an empty array" do
      expect(keywords).to eq([])
    end
  end

  context "with a single value" do
    let(:keywords) { described_class.parse(["tracción"]) }

    it "returns an array with a single value" do
      expect(keywords).to eq(["traccion"])
    end
  end

  context "with a UUID value" do
    let(:keywords) { described_class.parse(["faf394ad-00dc-4972-a61a-63425b24bd22"]) }

    it "returns an array with a single value" do
      expect(keywords).to eq(["faf394ad-00dc-4972-a61a-63425b24bd22"])
    end
  end

  context "with a many values" do
    let(:keywords) { described_class.parse(["tracción", "hello word"]) }

    it "returns an array with many values" do
      expect(keywords).to eq(["traccion", "hello", "word"])
    end
  end

  context "with a many values and UUID value" do
    let(:keywords) do
      described_class.parse(
        ["Good-day world", "$9.99", "a9d1c6f2-3a6b-4f4e-8e7d-3e3b1c9d9b2c"]
      )
    end

    it "returns an array with many values" do
      expect(keywords).to eq(
        ["good", "-", "day", "world", "$9.99", "a9d1c6f2-3a6b-4f4e-8e7d-3e3b1c9d9b2c"]
      )
    end
  end
end
