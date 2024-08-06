defmodule {app}.Config.ConfigHolder do
  use GenServer
  alias {app}.Config.AppConfig
  @table_name :{app_snake}_config

  @moduledoc """
  Provides Behaviours for handle app-configs
  """
  def start_link(%AppConfig{} = config) do
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  def init(%AppConfig{} = config) do
    if :ets.info(@table_name) == :undefined do
      @table_name = :ets.new(@table_name, [:public, :named_table, read_concurrency: true])
    end

    fullfilled_config = load_additional_properties(config)

    set(:config, fullfilled_config)

    {:ok, nil}
  end

  def conf(), do: get!(:config)

  def get!(key) do
    case get(key) do
      {:ok, conf} -> conf
      _ -> raise "Config with key #{inspect(key)} not found"
    end
  end

  def get(key) do
    case :ets.lookup(@table_name, key) do
      [{_, conf}] -> {:ok, conf}
      _ -> {:error, :not_found}
    end
  end

  def set(key, value) do
    true = :ets.insert(@table_name, {key, value})
  end

  defp load_additional_properties(%AppConfig{} = config) do
    Application.get_env(:poc_elix, :config_loaders, [])
    |> Enum.reduce(config, fn loader, fullfilled ->
      Map.merge(fullfilled, loader.load(fullfilled))
    end)
  end
end

defmodule {app}.Config.ConfigHolder.PropertiesLoaderBehaviour do
  alias {app}.Config.AppConfig

  @callback load(%AppConfig{}) :: map()
end
