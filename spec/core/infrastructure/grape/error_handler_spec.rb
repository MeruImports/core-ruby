# frozen_string_literal: true

RSpec.describe Core::Infrastructure::Grape::ErrorHandler do
  let(:dummy_class) do
    Class.new(::Grape::API) do
      helpers Core::Infrastructure::Grape::ErrorHandler
      rescue_from Grape::Exceptions::ValidationErrors, with: :schema_error!
      rescue_from Core::Domain::Error, with: :domain_error!
      params do
        requires :id, type: Integer
        optional :filter, type: String
      end
      get do
        raise Core::Domain::Criteria::InvalidFilterError, params[:filter]
      end
    end
  end
  let(:app) { Rack::MockRequest.new(dummy_class.new) }

  describe "#schema_error!" do
    context "when exception is InvalidIdError" do
      let(:response) { app.get("/", params: {id: "AVB"}) }
      let(:json_response) { JSON.parse(response.body) }

      it "returns error code" do
        expect(json_response["error_code"]).to eq("validation_error")
      end

      it "returns error message" do
        expect(json_response["message"]).to eq("Invalid params")
      end
    end
  end

  describe "#domain_error!" do
    context "when exception is InvalidFilterError" do
      let(:response) { app.get("/", params: {id: 123, filter: "AVB"}) }
      let(:json_response) { JSON.parse(response.body) }

      it "returns error code" do
        expect(json_response["error_code"]).to eq("invalid_filter")
      end

      it "returns error message" do
        expect(json_response["message"]).to eq("The filter AVB is not valid")
      end
    end
  end
end
