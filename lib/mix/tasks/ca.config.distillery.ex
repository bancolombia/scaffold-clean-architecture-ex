defmodule Mix.Tasks.Ca.Config.Distillery do
  @moduledoc """
  Creates distillery configuration for the clean architecture project
      $ mix ca.config.distillery
  """

  alias ElixirStructureManager.Utils.CommonCommands
  alias ElixirStructureManager.Core.ApplyTemplate
  alias Mix.Tasks.Ca.BaseTask

  use BaseTask,
    name: "ca.config.distillery",
    description: "Creates distillery configuration"

  def execute({[], []}) do
    ApplyTemplate.apply(:distillery, "non_required")
    CommonCommands.install_deps()
    CommonCommands.distillery_init()
  end

  def execute(_any), do: run(["-h"])
end
