defmodule {app}.Config.ConfigHolder do
  use Agent
  alias {app}.Config.AppConfig

  @moduledoc """
  Provides Behaviours for handle app-configs
  """
  def start_link(%AppConfig{} = conf), do: Agent.start_link(fn -> conf end, name: __MODULE__)
  def conf(), do: Agent.get(__MODULE__, & &1)

  def set(property, value) do
    Agent.update(__MODULE__, &(Map.put(&1, property, value)))
  end

end
