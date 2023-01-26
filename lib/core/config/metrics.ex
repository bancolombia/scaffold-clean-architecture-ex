defmodule Config.Metrics do
  @moduledoc false
  @base "/priv/templates/config/"
  @custom_telemetry "lib/utils/custom_telemetry.ex"

  def actions() do
    %{
      create: %{
        @custom_telemetry => @base <> "custom_telemetry.ex"
      },
      folders: [],
      transformations:
        [
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
          {:append_end, "config/prod.exs", @base <> "metrics/prod.ex"},
          {:replace, "mix.exs", "metrics: true", regex: ~r|metrics\: false|}
        ] ++ with_check(:redix) ++ with_check(:reactive_commons)
    }
  end

  def tokens(_opts) do
    []
  end

  def inject(%{} = base_actions, key) do
    new_trs =
      if Mix.Project.config()[:metrics] do
        Mix.shell().info(["Project with metrics:", :green, " enabled"])
        transformations(resolve(key))
      else
        Mix.shell().info(["Project with metrics:", :red, " disabled"])
        []
      end

    base_trs = Map.get(base_actions, :transformations, [])
    Map.put(base_actions, :transformations, base_trs ++ new_trs)
  end

  defp resolve(:redis), do: :redix
  defp resolve(:asynceventbus), do: :reactive_commons
  defp resolve(:asynceventhandler), do: :reactive_commons
  defp resolve(_other), do: nil

  defp with_check(key) do
    case Mix.Project.deps_apps() |> Enum.find_value(&(&1 == key)) do
      true -> transformations(key)
      _other -> []
    end
  end

  defp transformations(:redix) do
    attachment = """

        # Redis
        :telemetry.attach(\"{app_snake}-redis-stop\", [:redix, :pipeline, :stop], &CustomTelemetry.handle_custom_event/4, nil)
    """

    handler = """
    # Only for Redis
      def handle_custom_event([:redix, :pipeline, :stop], measures, metadata, _) do
        :telemetry.execute(
          [:elixir, :redis_request],
          %{duration: DataTypeUtils.monotonic_time_to_milliseconds(measures.duration)},
          %{commands: List.first(List.first(metadata.commands)), service: @service_name}
        )
      end

    """

    metrics = """

          #Redis
          counter("elixir.redis_request.count", tags: [:commands, :service]),
          sum("elixir.redis_request.duration", tags: [:commands, :service]),
    """

    [
      {:insert_after, @custom_telemetry, attachment,
       regex: ~r|def(\s)+custom_telemetry_events\(\)()(\s)+do|},
      {:insert_before, @custom_telemetry, handler, regex: ~r|def handle_custom_event\(metric|},
      {:insert_after, @custom_telemetry, metrics, regex: ~r|def metrics do(\s)+\[|},
      # Traces
      {:inject_dependency, ~s|{:opentelemetry_redix, "~> 0.1"}|},
      {:insert_after, "mix.exs", ", :opentelemetry_redix", regex: ~r|\[\:logger|},
      {:insert_before, "lib/application.ex", "OpentelemetryRedix.setup()\n    ",
        regex: ~r{opts = \[}},
    ]
  end

  defp transformations(:reactive_commons) do
    attachment = """

        # Reactive Commons
        :telemetry.attach("rcommons-success", [:async, :message, :completed], &CustomTelemetry.handle_custom_event/4, nil)
        :telemetry.attach("rcommons-event-failure", [:async, :event, :failure], &CustomTelemetry.handle_custom_event/4, nil)
        :telemetry.attach("rcommons-command-failure", [:async, :command, :failure], &CustomTelemetry.handle_custom_event/4, nil)
        :telemetry.attach("rcommons-query-failure", [:async, :query, :failure], &CustomTelemetry.handle_custom_event/4, nil)
    """

    metrics = """

          #Reactive Commons
          counter("elixir.async.message.completed.count", tags: [:transaction, :result, :service]),
          sum("elixir.async.message.completed.duration", tags: [:transaction, :result, :service]),
          counter("elixir.async.command.failure.count", tags: [:service]),
          sum("elixir.async.command.failure.duration", tags: [:service]),
          counter("elixir.async.event.failure.count", tags: [:service]),
          sum("elixir.async.event.failure.duration", tags: [:service]),
          counter("elixir.async.query.failure.count", tags: [:service]),
          sum("elixir.async.query.failure.duration", tags: [:service]),
    """

    [
      {:insert_after, @custom_telemetry, attachment,
       regex: ~r|def(\s)+custom_telemetry_events\(\)()(\s)+do|},
      {:insert_after, @custom_telemetry, metrics, regex: ~r|def metrics do(\s)+\[|}
    ]
  end

  defp transformations(_other), do: []
end
