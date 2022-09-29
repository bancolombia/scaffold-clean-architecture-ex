defmodule {app}.Adapters.Redis.RedisAdapter do

  alias {app}.Config.ConfigHolder

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    %{
      host: redis_host,
      port: redis_port
    } = ConfigHolder.conf().redis_props

    children = [
      {Redix, host: redis_host, port: String.to_integer(redis_port), name: :redix}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def health() do
    case Redix.command!(:redix, ["PING"]) do
      "PONG" -> {:ok, true}
      error -> {:error, error}
    end
  end

end
