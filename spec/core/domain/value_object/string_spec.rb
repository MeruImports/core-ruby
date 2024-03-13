# frozen_string_literal: true

RSpec.describe Core::Domain::ValueObject::String do
  before do
    module Dummy; end
    class Dummy::OwnerId < Core::Domain::ValueObject::String; end
  end

  context "Invalid String Error" do
    it "raises an InvalidStringError" do
      expect {
        Dummy::OwnerId.new("")
      }.to(raise_error do |error|
        expect(error).to be_a(Core::Domain::InvalidStringError)
        expect(error.error_message).to eq 'Owner id is not present'
        expect(error.error_code).to eq('owner_id_not_present')
      end)
    end
  end
end
