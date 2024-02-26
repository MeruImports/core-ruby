# frozen_string_literal: true

module Core
  module Domain
    class Criteria
      class OrderBy
        # @return [String]
        attr_reader :value

        # @param value [String]
        def initialize(value) = @value = value
      end
    end
  end
end
