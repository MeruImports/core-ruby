# frozen_string_literal: true

module Core
  module Infrastructure
    module Grape
      module ErrorHandler
        COMMON_ERRORS = {
          Domain::InvalidIdError => 422
        }.freeze

        def exceptions = COMMON_ERRORS.merge(errors)

        def errors = {}

        def domain_error!(exception)
          raise exception if exceptions.exclude?(exception.class)
          status_code = exceptions[exception.class]
          error!({error_code: exception.error_code, message: exception.message, errors: []}, status_code)
        end

        def schema_error!(exception)
          error!(
            {
              error_code: "validation_error",
              message: "Invalid params",
              errors: format_grape_errors(exception.as_json)
            },
            422
          )
        end

        private

        def format_grape_errors(errors_list)
          errors_list.each_with_object({}) do |error, parse_response|
            error[:params].each do |param|
              parse_response[param] ||= {source: param, details: []}
              parse_response[param][:details].concat(error[:messages]).uniq!
            end
          end.values
        end
      end
    end
  end
end
