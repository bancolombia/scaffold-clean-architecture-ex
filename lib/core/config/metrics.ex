defmodule Config.Metrics do
  @moduledoc false
  @base "/priv/templates/config/"

  def actions() do
    %{
      create: %{
        "lib/utils/custom_telemetry.ex" => @base <> "custom_telemetry.ex"
      },
      folders: [],
      transformations: [
        {:inject_dependency, ~s|{:telemetry_metrics_prometheus, "~> 1.1.0"}|},
        {:inject_dependency, ~s|{:telemetry_poller, "~> 0.5.1"}|},
        {:inject_dependency, ~s|{:telemetry, "~> 1.0", override: true}|},
        {:inject_dependency, ~s|{:opentelemetry_exporter, "~> 0.6.0"}|},
        {:inject_dependency, ~s|{:opentelemetry_api, "~> 0.6.0", override: true}|},
        {:inject_dependency,
         ~s|{:opentelemetry_plug, git: "https://github.com/juancgalvis/opentelemetry_plug.git", ref: "82206fb09fbeb9ffa2f167a5f58ea943c117c003", override: true}|},
        {:insert_after, "lib/application.ex", "\n  alias {app}.Utils.CustomTelemetry",
         regex: ~r{Utils\.CertificatesAdmin}},
        {:insert_before, "lib/application.ex", "CustomTelemetry.custom_telemetry_events()\n    ",
         regex: ~r{opts = \[}},
        {:insert_after, "lib/application.ex",
         ",\n      {TelemetryMetricsPrometheus, [metrics: CustomTelemetry.metrics()]}",
         regex: ~r|{ConfigHolder, AppConfig\.load_config\(\)}|}
      ]
    }
  end

  def tokens(_opts) do
    []
  end
end
