# frozen_string_literal: true

module Core
  module Domain
    class InvalidStringError < Error
      def initialize(attribute)
        @attribute_name = attribute[:name]
        @message_starter = attribute[:message]
        super()
      end

      # @return [String]
      def error_code = "#{@attribute_name}_not_present"

      # @return [String]
      def error_message = "#{@message_starter} no puede estar vacío(a)"
    end
  end
end
