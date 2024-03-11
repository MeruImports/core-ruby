# frozen_string_literal: true

module Shared
  module Infrastructure
    module Sneakers
      module Tracer
        def trace(name, payload = {})
          Datadog::Tracing.trace(
            "consume.#{name}",
            continue_from: extract_trace(payload),
            service: "rabbitmq"
          ) do |_span|
            yield
          end
        end

        def extract_trace(payload)
          trace = payload.fetch("trace", {})
          Datadog::Tracing::TraceDigest.new(
            span_id: trace["parent_id"],
            trace_id: trace["trace_id"]
          )
        end
      end
    end
  end
end
