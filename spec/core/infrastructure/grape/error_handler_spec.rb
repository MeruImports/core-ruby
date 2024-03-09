# frozen_string_literal: true

module Core
  module Infrastructure
    module Grape
      RSpec.describe ErrorHandler do
        let(:dummy_class) do
          Class.new(::Grape::API) do
            helpers ::Core::Infrastructure::Grape::ErrorHandler
            rescue_from ::Grape::Exceptions::ValidationErrors, with: :schema_error!
            rescue_from ::Core::Domain::Error, with: :domain_error!
            params do
              requires :id, type: Integer
              optional :filter, type: String
            end
            get do
              raise Domain::Criteria::InvalidFilterError, params[:filter]
            end
          end
        end
        let(:app) { Rack::MockRequest.new(dummy_class.new) }
        describe "#schema_error!" do
          it "when exception is InvalidIdError" do
            response = app.get("/", params: {id: "AVB"})
            json_response = JSON.parse(response.body)
            expect(json_response["error_code"]).to eq("validation_error")
            expect(json_response["message"]).to eq("Invalid params")
          end
        end
        describe "#domain_error!" do
          it "when exception is InvalidFilterError" do
            response = app.get("/", params: {id: 123, filter: "AVB"})
            json_response = JSON.parse(response.body)
            expect(json_response["error_code"]).to eq("invalid_filter")
            expect(json_response["message"]).to eq("The filter AVB is not valid")
          end
        end
      end
    end
  end
end
