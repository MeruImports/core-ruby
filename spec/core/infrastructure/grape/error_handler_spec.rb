module Core
  module Infrastructure
    module Grape
      RSpec.describe ErrorHandler do
        let(:dummy_class) do
          Class.new do
            extend ErrorHandler
            def self.error!(message, status) = [message, status]
          end
        end

        describe "#domain_error!" do
          before do
            allow(dummy_class).to receive(:exceptions).and_return({})
          end

          context "when exception is InvalidIdError" do
            let(:exception) { ::Core::Domain::InvalidIdError.new("3fa85f64-5717-4562-b3fc-2c963f66afa633") }
            it "raises the exception if it is not in the exceptions list" do
              expect { dummy_class.domain_error!(exception) }.to raise_error(::Core::Domain::InvalidIdError)
            end
          end

          context "when exception is InvalidFilterError" do
            let(:exception) { ::Core::Domain::Criteria::InvalidFilterError.new("filterr") }
            it "raises the exception if it is not in the exceptions list" do
              expect { dummy_class.domain_error!(exception) }.to raise_error(::Core::Domain::Criteria::InvalidFilterError)
            end
          end
        end

        describe "#schema_error!" do
          let(:exception) do
            instance_double(
              "Grape::Exceptions::ValidationErrors",
              as_json: [
                {
                  params: [:param1],
                  messages: ["message1"]
                },
                {
                  params: [:param2],
                  messages: ["message2"]
                }
              ]
            )
          end

          before do
            allow(dummy_class).to receive(:error!)
          end

          it "returns an error response" do
            dummy_class.schema_error!(exception)
            expect(dummy_class).to have_received(:error!).with(
              {
                error_code: "validation_error",
                message: "Invalid params",
                errors: [
                  {
                    source: :param1,
                    details: ["message1"]
                  },
                  {
                    source: :param2,
                    details: ["message2"]
                  }
                ]
              },
              422
            )
          end
        end
      end
    end
  end
end
