

  def check_redis do
    case {app}.Adapters.Redis.RedisAdapter.health() do
      {:ok, true} -> :ok
      {:error, error} -> {:error, error}
    end
  end
