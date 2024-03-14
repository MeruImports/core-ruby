# frozen_string_literal: true

RSpec.describe Core::Domain::ValueObject::Integer do
  let(:dummy_kilometrage) { Class.new(Core::Domain::ValueObject::Integer) }

  before do
    stub_const("Dummy::Kilometrage", dummy_kilometrage)
  end

  context "Valid Integer" do
    it "does not raise an error" do
      expect { Dummy::Kilometrage.new(5) }.not_to raise_error
    end
  end

  context "Invalid Integer Error" do
    it "raises an InvalidIntegerError" do
      expect {
        Dummy::Kilometrage.new("")
      }.to(raise_error do |error|
        expect(error).to be_a(Core::Domain::InvalidIntegerError)
        expect(error.error_code).to eq("kilometrage_not_present")
        expect(error.error_message).to eq "Kilometrage is not present"
      end)
    end

    it "raises an InvalidIntegerError when nil" do
      expect {
        Dummy::Kilometrage.new(nil)
      }.to(raise_error do |error|
        expect(error).to be_a(Core::Domain::InvalidIntegerError)
        expect(error.error_code).to eq("kilometrage_not_present")
        expect(error.error_message).to eq "Kilometrage is not present"
      end)
    end
  end
end
