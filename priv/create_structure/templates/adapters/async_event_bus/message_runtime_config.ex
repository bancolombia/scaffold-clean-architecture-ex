defmodule {module_name}.Adapters.MessageRuntimeConfig do
  alias {module_name}.Config.{ConfigHolder, AppConfig}
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      {MessageRuntime, config()}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp config() do
    ConfigHolder.conf()
    |> merge()
  end

  defp merge(%AppConfig{exchange: params}) do
    Application.get_application(__MODULE__)
    |> Atom.to_string()
    |> AsyncConfig.new()
    |> Map.merge(params)
  end
end
