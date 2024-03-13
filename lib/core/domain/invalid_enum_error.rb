# frozen_string_literal: true

module Core
  module Domain
    class InvalidEnumError < Error
      def initialize(klass)
        @klass = klass
        super()
      end

      # @return [String]
      def error_code = "#{@klass.underscore}_not_available"

      # @return [String]
      def error_message = "#{@klass.underscore.tr("_", " ").humanize} is not available"
    end
  end
end
