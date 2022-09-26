defmodule Mix.Tasks.Ca.Config.Metrics do
  @moduledoc """
  Creates distillery configuration for the clean architecture project
      $ mix ca.config.metrics
  """

  alias ElixirStructureManager.Utils.CommonCommands
  alias ElixirStructureManager.Core.ApplyTemplate
  alias Mix.Tasks.Ca.BaseTask

  use BaseTask,
    name: "ca.config.metrics",
    description: "Adds telemetry configuration"

  def execute({[], []}) do
    ApplyTemplate.apply(:metrics, "non_required")
    CommonCommands.install_deps()
  end

  def execute(_any), do: run(["-h"])
end
