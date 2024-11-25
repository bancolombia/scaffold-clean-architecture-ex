defmodule {app}.Utils.CustomTelemetryTest do
  alias {app}.Utils.CustomTelemetry
  use ExUnit.Case

  setup do
    :telemetry.detach("test-handler")
    :ok
  end

  test "execute_custom_event emits the event with correct metric, value, and metadata" do
    event_name = [:elixir, :custom, :metric]
    metric = [:custom, :metric]
    value = 200
    metadata = %{source: "api"}
    service_name = "{app_snake}_test"

    Application.put_env(:test, :service_name, service_name)

    :telemetry.attach(
      "test-handler",
      event_name,
      fn _event_name, measurements, event_metadata, _config ->
        send(self(), {:event_received, measurements, event_metadata})
      end,
      nil
    )

    CustomTelemetry.execute_custom_event(metric, value, metadata)

    assert_receive {:event_received, %{duration: ^value},
                    %{source: "api", service: ^service_name}}

    :telemetry.detach("test-handler")
  end

  test "execute_custom_event adds service name to metadata" do
    event_name = [:elixir, :another, :metric]
    metric = [:another, :metric]
    value = 100
    metadata = %{}
    service_name = "{app_snake}_test"

    Application.put_env(:test, :service_name, service_name)

    :telemetry.attach(
      "test-handler",
      event_name,
      fn _event_name, measurements, event_metadata, _config ->
        send(self(), {:event_received, measurements, event_metadata})
      end,
      nil
    )

    CustomTelemetry.execute_custom_event(metric, value, metadata)

    assert_receive {:event_received, %{duration: ^value}, %{service: ^service_name}}

    :telemetry.detach("test-handler")
  end

  test "handle_custom_event emits the event with correct metric, measures, and metadata" do
    event_name = [:elixir, :custom, :metric]
    metric = [:custom, :metric]
    measures = %{duration: 200}
    metadata = %{source: "api"}
    service_name = "{app_snake}_test"

    Application.put_env(:test, :service_name, service_name)

    :telemetry.attach(
      "test-handler",
      event_name,
      fn _event_name, event_measures, event_metadata, _config ->
        send(self(), {:event_received, event_measures, event_metadata})
      end,
      nil
    )

    CustomTelemetry.handle_custom_event(metric, measures, metadata, nil)

    assert_receive {:event_received, ^measures, %{source: "api", service: ^service_name}}

    :telemetry.detach("test-handler")
  end

  test "handle_custom_event adds service name to metadata" do
    event_name = [:elixir, :another, :metric]
    metric = [:another, :metric]
    measures = %{count: 100}
    metadata = %{}
    service_name = "{app_snake}_test"

    Application.put_env(:{app_snake}, :service_name, service_name)

    :telemetry.attach(
      "test-handler",
      event_name,
      fn _event_name, event_measures, event_metadata, _config ->
        send(self(), {:event_received, event_measures, event_metadata})
      end,
      nil
    )

    CustomTelemetry.handle_custom_event(metric, measures, metadata, nil)

    assert_receive {:event_received, ^measures, %{service: ^service_name}}

    :telemetry.detach("test-handler")
  end

  test "execute_custom_event handles atom metric by delegating to list implementation" do
    metric = :custom_event
    value = 100
    metadata = %{source: "test_source"}
    expected_metric_list = [metric]

    :telemetry.attach(
      "test-handler",
      [:elixir | expected_metric_list],
      fn _event_name, measurements, event_metadata, _config ->
        send(self(), {:event_received, measurements, event_metadata})
      end,
      nil
    )

    CustomTelemetry.execute_custom_event(metric, value, metadata)

    assert_receive {:event_received, %{duration: ^value}, event_metadata}

    assert event_metadata[:source] == "test_source"
  end

  test "execute_custom_event emits the correct event with default metadata" do
    metric = [:custom, :event]
    value = 200
    expected_metadata = %{service: "{app_snake}_test"}

    :telemetry.attach(
      "test-handler-default-metadata",
      [:elixir | metric],
      fn _event_name, measurements, event_metadata, _config ->
        send(self(), {:event_received, measurements, event_metadata})
      end,
      nil
    )

    CustomTelemetry.execute_custom_event(metric, value)

    assert_receive {:event_received, %{duration: ^value}, event_metadata}
    assert event_metadata == expected_metadata
  end

end
