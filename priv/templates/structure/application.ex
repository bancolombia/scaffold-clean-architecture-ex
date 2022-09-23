defmodule {app}.Application do

  alias {app}.EntryPoint.ApiRest
  alias {app}.Config.{AppConfig, ConfigHolder}
  alias {app}.Utils.CustomTelemetry
  alias {app}.Utils.CertificatesAdmin

  use Application
  require Logger

  def start(_type, _args) do
    config = AppConfig.load_config()
    in_test? = {:ok, Mix.env() == :test}

    CertificatesAdmin.setup()

    children = with_plug_server(config) ++ application_children(in_test?)

    CustomTelemetry.custom_telemetry_events()
    opts = [strategy: :one_for_one, name: {app}.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp with_plug_server(%AppConfig{enable_server: true, http_port: port}) do
    Logger.debug("Configure Http server in port #{inspect(port)}. ")

    [
      {
        Plug.Cowboy,
        scheme: :http,
        plug: ApiRest,
        options: [
          port: port
        ]
      }
    ]
  end

  defp with_plug_server(%AppConfig{enable_server: false}), do: []

  def application_children({:ok, true} = _test_env),
    do: [
      {ConfigHolder, AppConfig.load_config()},
      {TelemetryMetricsPrometheus, [metrics: CustomTelemetry.metrics()]}
    ]

  def application_children(_other_env) do
    [
      {ConfigHolder, AppConfig.load_config()},
      {TelemetryMetricsPrometheus, [metrics: CustomTelemetry.metrics()]}
    ]
  end
end
