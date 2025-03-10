
# tracer
config :opentelemetry,
  text_map_propagators: [:baggage, :trace_context],
  span_processor: :batch,
  traces_exporter: :otlp,
  resource_detectors: [
    :otel_resource_app_env,
    :otel_resource_env_var,
    OtelResourceDynatrace
]

config :opentelemetry_exporter,
  otlp_protocol: :http_protobuf,
  otlp_endpoint: "http://localhost:4318"
