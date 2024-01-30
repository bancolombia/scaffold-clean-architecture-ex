defmodule Config.Metrics do
  @moduledoc false
  @base "/priv/templates/config/metrics/"
  @custom_telemetry "lib/utils/custom_telemetry.ex"

  def actions do
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
          {:append_end, "config/dev.exs", @base <> "dev.ex"},
          {:append_end, "config/test.exs", @base <> "dev.ex"},
          {:append_end, "config/prod.exs", @base <> "prod.ex"},
          {:replace, "mix.exs", "metrics: true", regex: ~r|metrics\: false|}
        ] ++
          with_check(:redix) ++
          with_check(:reactive_commons) ++
          with_check(:postgrex) ++
          with_check(:finch) ++
          with_check(:ex_aws) ++
          [{:run_task, :install_deps}]
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

  # This function should map from adapter name to specific library name
  defp resolve(:redis), do: :redix
  defp resolve(:asynceventbus), do: :reactive_commons
  defp resolve(:asynceventhandler), do: :reactive_commons
  defp resolve(:repository), do: :postgrex
  defp resolve(:restconsumer), do: :finch
  defp resolve(:secretsmanager), do: :ex_aws
  defp resolve(:dynamo), do: :ex_aws
  defp resolve(:cognitotokenprovider), do: :ex_aws
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
        :telemetry.attach(\"{app_snake}-redis-stop\", [:redix, :pipeline, :stop], &__MODULE__.handle_custom_event/4, nil)
    """

    handler = """
    # Redis
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
       regex: ~r{opts = \[}}
    ]
  end

  defp transformations(:postgrex) do
    handler = """
    # Ecto
      def extract_metadata(%{source: source, result: {_, %{command: command}}}) do
        %{source: source, command: command, service: @service_name}
      end

    """

    metrics = """

          #Ecto
          counter("elixir.repo.query.count",
            tag_values: &__MODULE__.extract_metadata/1,
            tags: [:source, :command, :service]
          ),
          distribution("elixir.repo.query.total_time",
            tag_values: &__MODULE__.extract_metadata/1,
            unit: {:native, :millisecond},
            tags: [:source, :command, :service],
            reporter_options: [
              buckets: [100, 200, 500]
            ]
          ),
    """

    [
      {:insert_before, @custom_telemetry, handler, regex: ~r|def metrics do|},
      {:insert_after, @custom_telemetry, metrics, regex: ~r|def metrics do(\s)+\[|},
      # Traces
      {:inject_dependency, ~s|{:opentelemetry_ecto, "~> 1.0"}|},
      {:insert_before, "lib/application.ex", "OpentelemetryEcto.setup([:elixir, :repo])\n    ",
       regex: ~r{opts = \[}}
    ]
  end

  defp transformations(:finch) do
    handler = """
    # Finch
      def extract_metadata(%{
            name: HttpFinch,
            request: %{method: method, scheme: scheme, host: host, port: port, path: path},
            result: {_, %{status: status}}
          }) do
        %{
          request_path: "\#{method} \#{scheme}://\#{host}:\#{port}\#{path}",
          status: "\#{status}",
          service: @service_name
        }
      end

    """

    metrics = """

          # Http Outgoing Requests
          counter("elixir.http_outgoing_request.count",
            event_name: [:finch, :request, :stop],
            tag_values: &__MODULE__.extract_metadata/1,
            tags: [:service, :request_path, :status]
          ),
          sum(
            "elixir.http_outgoing_request.duration",
            event_name: [:finch, :request, :stop],
            measurement: :duration,
            unit: {:native, :nanosecond},
            tag_values: &__MODULE__.extract_metadata/1,
            tags: [:service, :request_path, :status]
          ),
    """

    [
      {:insert_before, @custom_telemetry, handler, regex: ~r|def metrics do|},
      {:insert_after, @custom_telemetry, metrics, regex: ~r|def metrics do(\s)+\[|},
      # Traces
      {:inject_dependency, ~s|{:opentelemetry_finch, "~> 0.1"}|},
      {:insert_before, "lib/application.ex", "OpentelemetryFinch.setup()\n    ",
       regex: ~r{opts = \[}}
    ]
  end

  defp transformations(:reactive_commons) do
    attachment = """

        # Reactive Commons
        :telemetry.attach("rcommons-success", [:async, :message, :completed], &__MODULE__.handle_custom_event/4, nil)
        :telemetry.attach("rcommons-event-failure", [:async, :event, :failure], &__MODULE__.handle_custom_event/4, nil)
        :telemetry.attach("rcommons-command-failure", [:async, :command, :failure], &__MODULE__.handle_custom_event/4, nil)
        :telemetry.attach("rcommons-query-failure", [:async, :query, :failure], &__MODULE__.handle_custom_event/4, nil)
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

  defp transformations(:ex_aws) do
    attachment = """

        # AWS
        :telemetry.attach(\"{app_snake}-aws\", [:ex_aws, :request, :stop], &__MODULE__.handle_custom_event_ex_aws/4, nil)
    """

    handler = """
    # AWS
      def handle_custom_event_ex_aws(_, measures, %{service: svc, attempt: atm, result: rs} = meta, _) do
        # Traces
        attributes = %{"aws.service" => svc, "aws.attempt" => atm, "aws.result" => rs}

        sp =
          OpenTelemetry.Tracer.start_span("AWS \#{svc}", %{
            start_time: :opentelemetry.timestamp() - measures.duration,
            attributes: attributes,
            kind: :client
          })

        if rs == :error do
          OpenTelemetry.Span.set_status(sp, OpenTelemetry.status(:error, "Error attempt \#{atm}"))
        end

        OpenTelemetry.Span.end_span(sp)
        # Metrics
        new_meta = Map.put(meta, :service, @service_name) |> Map.put(:aws_service, svc)
        :telemetry.execute([:elixir, :ex_aws, :request], measures, new_meta)
      end

    """

    metrics = """

          # AWS
          counter("elixir.ex_aws.request.count", tags: [:result, :service, :aws_service]),
          sum("elixir.ex_aws.request.duration", tags: [:result, :service, :aws_service]),
    """

    [
      {:insert_after, @custom_telemetry, attachment,
       regex: ~r|def(\s)+custom_telemetry_events\(\)()(\s)+do|},
      {:insert_before, @custom_telemetry, handler, regex: ~r|def handle_custom_event\(metric|},
      {:insert_after, @custom_telemetry, metrics, regex: ~r|def metrics do(\s)+\[|},
      {:insert_after, @custom_telemetry, "\n  require OpenTelemetry.Tracer",
       regex: ~r|Telemetry\.Metrics|}
    ]
  end

  defp transformations(_other), do: []
end
