defmodule {app}.Infrastructure.Adapters.AsyncMessages do
  @moduledoc false
  # @behaviour Your.Own.Behaviour
  @target "external-service-name"
  @query_name "GetPerson"
  @command_name "RegisterPerson"
  @event_name "PersonRegistered"
  @notification_event_name "ConfigurationChanged"

  # @impl true
  def emit(event_data) do
    # it returns :ok when success
    DomainEvent.new(@event_name, event_data)
    |> DomainEventBus.emit()
  end

  # @impl true
  def run_remote_task(command_data) do
    # it returns :ok when success
    Command.new(@command_name, command_data)
    |> DirectAsyncGateway.send_command(@target)
  end

  # @impl true
  def get_remote_information(query_data) do
    # it returns {:ok, response} when success
    AsyncQuery.new(@query_name, query_data)
    |> DirectAsyncGateway.request_reply_wait(@target)
  end
end
