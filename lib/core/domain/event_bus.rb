# frozen_string_literal: true

module Core
  module Domain
    module EventBus
      # @param events [Array<Event>]
      # return [void]
      def publish(events) = raise NotImplementedError
    end
  end
end
