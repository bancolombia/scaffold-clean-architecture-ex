defmodule {app}.Infrastructure.Adapters.Secrets.SecretManagerAdapter do
  use GenServer
  alias {app}.Config.ConfigHolder
  alias {app}.Utils.DataTypeUtils
  @compile if Mix.env == :test, do: :export_all

  @moduledoc """
  Provides functions for handle secrets from AWS
  """

  def start_link(async_init) do
    GenServer.start_link(__MODULE__, async_init, name: __MODULE__)
  end

  def init(true = _async_init) do
    create_ets()
    send(self(), :get_secret)
    {:ok, nil}
  end

  def init(_async_init) do
    create_ets()
    {:ok, get_initial_secret()}
  end

  defp create_ets do
    :ets.new(:secret_manager_adapter, [:named_table, read_concurrency: true])
  end

  def handle_info(:get_secret, _args) do
    {:noreply, get_initial_secret()}
  end

  defp get_initial_secret() do
    if Mix.env() == :prod do
      secret_name = ConfigHolder.conf.secret_name
      secret = get_secret_value(secret_name)
               |> Poison.decode!
               |> DataTypeUtils.normalize
      :ets.insert(:secret_manager_adapter, {:secret, secret})
      secret
   end
  end

  def get_secret() do
    if Mix.env() == :prod do
      case :ets.lookup(:secret_manager_adapter, :secret) do
        [{_, secret}] -> secret
        _ -> GenServer.call(__MODULE__, :get_secret)
      end
    else
      ConfigHolder.conf
    end
  end

  def handle_call(:get_secret, _from, state) do
    {:reply, state, state}
  end

  defp get_secret_value(secret_name) do
    cfg = ExAws.Config.build_base(:secretsmanager)
    region = ExAws.Config.retrieve_runtime_value(cfg.region, cfg)
    ExAws.SecretsManager.get_secret_value(secret_name)
    |> ExAws.request(region: region)
    |> case do
         {:ok, %{"SecretString" => secret_string}} -> secret_string
         {code, rs} -> {code, rs}
         no_expected -> {:error, no_expected}
       end
  end

end
