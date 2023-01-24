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
        {:inject_dependency, ~s|{:telemetry_metrics_prometheus, "~> 1.0"}|},
        {:inject_dependency, ~s|{:telemetry_poller, "~> 1.0"}|},
        {:inject_dependency, ~s|{:telemetry, "~> 1.0"}|},
        {:inject_dependency, ~s|{:opentelemetry_exporter, "~> 1.0"}|},
        {:inject_dependency, ~s|{:opentelemetry_api, "~> 1.0"}|},
        {:inject_dependency,
         ~s|{:opentelemetry_plug, git: "https://github.com/juancgalvis/opentelemetry_plug.git", tag: "master"}|},
        {:insert_after, "lib/application.ex", "\n  alias {app}.Utils.CustomTelemetry",
         regex: ~r{Utils\.CertificatesAdmin}},
        {:insert_before, "lib/application.ex",
         "CustomTelemetry.custom_telemetry_events()\n    OpentelemetryPlug.setup()\n    ",
         regex: ~r{opts = \[}},
        {:insert_after, "lib/application.ex",
         ",\n      {TelemetryMetricsPrometheus, [metrics: CustomTelemetry.metrics()]}",
         regex: ~r|{ConfigHolder, AppConfig\.load_config\(\)}|},
        {:insert_after, "lib/infrastructure/entry_points/api_rest.ex",
         "\n  plug OpentelemetryPlug.Propagation", regex: ~r|plug\(\:match\)|},
        {:insert_after, "mix.exs", ", :opentelemetry_exporter, :opentelemetry",
         regex: ~r|\[\:logger|},
        {:append_end, "config/dev.exs", @base <> "metrics/dev.ex"},
        {:append_end, "config/test.exs", @base <> "metrics/dev.ex"},
        {:append_end, "config/prod.exs", @base <> "metrics/prod.ex"}
      ]
    }
  end

  def tokens(_opts) do
    []
  end
end
