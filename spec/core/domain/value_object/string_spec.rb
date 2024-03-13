# frozen_string_literal: true

RSpec.describe Core::Domain::ValueObject::String do
  let(:dummy_owner_id) { Class.new(Core::Domain::ValueObject::String) }

  before do
    stub_const("Dummy::OwnerId", dummy_owner_id)
  end

  context "Invalid String Error" do
    it "raises an InvalidStringError" do
      expect {
        Dummy::OwnerId.new("")
      }.to(raise_error do |error|
        expect(error).to be_a(Core::Domain::InvalidStringError)
        expect(error.error_message).to eq "Owner id is not present"
        expect(error.error_code).to eq("owner_id_not_present")
      end)
    end
  end
end
