import Config

config :{app_snake}, timezone: "America/Bogota"

config :{app_snake},
  http_port: 8083,
  enable_server: true,
  secret_name: "",
  version: "0.0.1",
  in_test: false,
  custom_metrics_prefix_name: "{app_snake}"

config :logger,
  level: :warning
