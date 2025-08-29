defmodule {app}.Infrastructure.Adapters.Redis.RedisAdapter do
  ## TODO: Update behaviour name
  # @behaviour {app}.Domain.Behaviours.CacheBehaviour

  def get(key) do
    case RedixPool.command(:redix_read, ["GET", key], []) do
      {:ok, nil} -> {:error, :not_found}
      {:ok, value} -> {:ok, value}
      {:error, reason} -> {:error, reason}
    end
  end

  def set(key, value) do
    case RedixPool.command(:redix, ["SET", key, value], []) do
      {:ok, _} -> :ok
      {:error, reason} -> {:error, reason}
    end
  end

end
