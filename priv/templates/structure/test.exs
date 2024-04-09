import Config

config :{app_snake}, timezone: "America/Bogota"

config :{app_snake},
  http_port: 8083,
  enable_server: true,
  secret_name: "",
  version: "0.0.1",
  in_test: true,
  custom_metrics_prefix_name: "{app_snake}_test"

config :logger,
  level: :info

config :junit_formatter,
  report_dir: "_build/release",
  report_file: "test-junit-report.xml"

config :elixir_structure_manager,
  container_file: "Dockerfile-build",
  container_base_image: "1.16.2-otp-26-alpine", # change by your preferred image
  container_tool: "docker"
