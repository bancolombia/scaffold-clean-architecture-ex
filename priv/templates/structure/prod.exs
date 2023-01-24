import Config

config :{app_snake}, timezone: "America/Bogota"

config :{app_snake},
  http_port: 8083,
  enable_server: true,
  secret_name: "",
  region: "",
  version: "0.0.1",
  in_test: false,
  custom_metrics_prefix_name: "{app_snake}_local"

config :logger,
  level: :warning
