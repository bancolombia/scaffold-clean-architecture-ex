import Config

config :{app_snake}, timezone: "America/Bogota"

config :{app_snake},
  env: :dev,
  http_port: 8083,
  enable_server: true,
  version: "0.0.1",
  custom_metrics_prefix_name: "{app_snake}_local"

config :logger,
  level: :debug
