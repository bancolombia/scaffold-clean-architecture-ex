defmodule {app}.Infrastructure.Adapters.Redis.RedisSetup do
  alias {app}.Config.ConfigHolder
  use Supervisor
  @default_backoff_max 5_000
  @default_pool_size 1

  @moduledoc """
  This is the setup for the Redis adapter.
  You may set the properties like:

  config :{app_snake}, :redis_props, %{
      host: "localhost",
      hostread: "localhost",
      port: 6379,
      username: "aaaa",
      password: "bbbb",
      ssl: true | false,
      pool_size: 1,
      backoff_max: 5_000
  }

  If you are using secrets, the secret should have the same keys (not all only required, for example: host, port or username and password) as the config.
  """

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    config = resolve_config(ConfigHolder.conf())
    redis_opts = map_properties(config)

    redis_opts_read =
      Keyword.put(redis_opts, :host, Map.get(config, :hostread, Map.get(config, :host)))

    pool_size = Map.get(config, :pool_size, @default_pool_size)

    children = [
      Supervisor.child_spec(
        {RedixPool, pool_name: :redix, pool_size: pool_size, redix_param: redis_opts},
        id: RedixPool
      ),
      Supervisor.child_spec(
        {RedixPool, pool_name: :redix_read, pool_size: pool_size, redix_param: redis_opts_read},
        id: RedixPoolRead
      )
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def health() do
    case RedixPool.command!(:redix, ["PING"], []) do
      "PONG" -> :ok
      error -> {:error, error}
    end
  end

  def map_properties(config = %{}) do
    map_basic(config)
    |> with_credentials(config)
    |> with_ssl(config)
    |> with_backoff(config)
  end

  defp map_basic(config = %{port: port}) when is_binary(port) do
    map_basic(%{config | port: String.to_integer(port)})
  end

  defp map_basic(_config = %{host: host, port: port}) do
    [host: host, port: port]
  end

  defp with_credentials(opts, _config = %{username: username, password: password}) do
    opts
    |> Keyword.put(:username, username)
    |> Keyword.put(:password, password)
  end

  defp with_credentials(opts, _), do: opts

  defp with_ssl(opts, _config = %{ssl: true}) do
    ssl_opts = [
      customize_hostname_check: [
        match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
      ]
    ]

    opts
    |> Keyword.put(:ssl, true)
    |> Keyword.put(:ssl_opts, ssl_opts)
  end
  defp with_ssl(opts, _), do: opts

  defp with_backoff(opts, config = %{}) do
    opts
    |> Keyword.put(:backoff_max, Map.get(config, :backoff_max, @default_backoff_max))
  end

  defp resolve_config(%{redis_props: props, redis_secret: secret}), do: Map.merge(props, secret)
  defp resolve_config(%{redis_props: props}), do: props
end
