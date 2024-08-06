defmodule {app}.Infrastructure.Adapters.Secrets.SecretManagerAdapter do
  alias {app}.Config.{ConfigHolder, AppConfig}
  alias {app}.Utils.DataTypeUtils
  require Logger
  @compile if Mix.env() == :test, do: :export_all

  @behaviour {app}.Config.ConfigHolder.PropertiesLoaderBehaviour

  @moduledoc """
  Provides functions for handle secrets from AWS
  """

  @impl true
  def load(%AppConfig{env: env, secret_name: secret_name}) do
    if env == :prod do
      Logger.info("Loading secret #{secret_name} from AWS Secrets Manager")
      secret = get_secret(secret_name)
      # TODO: Load another cacheable secrets here
      %{secret: secret}
    else
      %{}
    end
  end

  def get_secret(secret_name, cached \\ true)

  def get_secret(secret_name, true = _cached) do
    case ConfigHolder.get(secret_name) do
      {:ok, secret} ->
        secret

      _ ->
        load_and_cache(secret_name)
    end
  end

  def get_secret(secret_name, false = _cached) do
    get_secret_value(secret_name) |> parse_secret()
  end

  defp load_and_cache(secret_name) do
    secret = get_secret_value(secret_name) |> parse_secret()
    ConfigHolder.set(secret_name, secret)
    secret
  end

  defp get_secret_value(secret_name) do
    cfg = ExAws.Config.build_base(:secretsmanager)
    region = ExAws.Config.retrieve_runtime_value(cfg.region, cfg)

    ExAws.SecretsManager.get_secret_value(secret_name)
    |> ExAws.request(region: region)
    |> case do
      {:ok, %{"SecretString" => secret_string}} -> secret_string
      {code, rs} -> {code, rs}
    end
  end

  defp parse_secret(secret_string) do
    secret_string
    |> Poison.decode!()
    |> DataTypeUtils.normalize()
  end
end
