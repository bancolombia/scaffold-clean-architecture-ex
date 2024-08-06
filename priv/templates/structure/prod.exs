import Config

config :{app_snake},
  timezone: "America/Bogota",
  env: :prod,
  http_port: 8083,
  enable_server: true,
  version: "0.0.1",
  custom_metrics_prefix_name: "{app_snake}"

config :logger,
  level: :warning
