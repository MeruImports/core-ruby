# frozen_string_literal: true

RSpec.describe Core::Domain::ValueObject::Enum do
  let(:dummy_color) { Class.new(Core::Domain::ValueObject::Enum) }

  before do
    stub_const("Dummy::Color", dummy_color)
  end

  context "Invalid Enum Error" do
    it "raises an InvalidEnumError" do
      expect {
        Dummy::Color.new("pink")
      }.to(raise_error do |error|
        expect(error).to be_a(Core::Domain::InvalidEnumError)
        expect(error.error_code).to eq("color_not_available")
        expect(error.error_message).to eq "Color is not available"
      end)
    end
  end
end
