# frozen_string_literal: true

module Core
  module Domain
    class InvalidStringError < Error
      def initialize(klass)
        @klass = klass
        super()
      end

      # @return [String]
      def error_code = "#{@klass.underscore}_not_present"

      # @return [String]
      def error_message = "#{@klass.underscore.gsub("_", " ").humanize} is not present"
    end
  end
end
