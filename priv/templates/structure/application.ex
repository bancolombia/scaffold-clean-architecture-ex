defmodule {app}.Application do
  @moduledoc """
  {app} application
  """

  alias {app}.Infrastructure.EntryPoint.ApiRest
  alias {app}.Config.{AppConfig, ConfigHolder}

  use Application
  require Logger

  def start(_type, [env]) do
    config = AppConfig.load_config()

    children = with_plug_server(config) ++ all_env_children() ++ env_children(env)

    opts = [strategy: :one_for_one, name: {app}.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp with_plug_server(%AppConfig{enable_server: true, http_port: port}) do
    Logger.debug("Configure Http server in port #{inspect(port)}. ")
    [{Plug.Cowboy, scheme: :http, plug: ApiRest, options: [port: port]}]
  end

  defp with_plug_server(%AppConfig{enable_server: false}), do: []

  def all_env_children() do
    [
      {ConfigHolder, AppConfig.load_config()}
    ]
  end

  def env_children(:test) do
    []
  end

  def env_children(_other_env) do
    []
  end
end
