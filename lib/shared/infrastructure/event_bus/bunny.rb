# frozen_string_literal: true

module Shared
  module Infrastructure
    module EventBus
      class Bunny
        include Core::Domain::EventBus

        def initialize = @connection = ::Bunny.new

        # @param events [Array<Core::Domain::Event>]
        # @return [void]
        def publish(events)
          @connection.start
          channel = @connection.create_channel
          events.each do |event|
            Datadog::Tracing.trace("publish.#{event.event_name}", service: "rabbitmq") do |span|
              trace = span.to_hash
              exchange = channel.queue(event.event_name, durable: true)
              exchange.publish(JSON.parse(event.to_json).merge(trace:).to_json)
            end
          end
          @connection.close
        end
      end
    end
  end
end
