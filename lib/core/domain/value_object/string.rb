# frozen_string_literal: true

module Core
  module Domain
    module ValueObject
      class String
        MESSAGE_STARTERS = {
            owner_id: 'El id del propietario',
            license_plate: 'La placa',
            make: 'La marca',
            model: 'El modelo'
          }
        # @param value [String]
        def initialize(value)
          @value = value
          name = formatter[0]
          message = formatter[1]
          ensure_valid_string(name, message)
        end

        # @return [String]
        attr_reader :value

        private

        def ensure_valid_string(name, message)
          raise InvalidStringError, {name:, message:} if @value.strip.empty?
        end

        def formatter
          children_class_name = self.class.name.split('::').last
          name = children_class_name.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
          message = MESSAGE_STARTERS[name.to_sym]
          [name, message]
        end
      end
    end
  end
end
