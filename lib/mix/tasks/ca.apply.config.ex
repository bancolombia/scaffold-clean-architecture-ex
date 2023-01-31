defmodule Mix.Tasks.Ca.Apply.Config do
  @moduledoc """
  Applies common configuration to the clean architecture project
  mix ca.apply.config --type config_name

  Type param options:

  * distillery
  * metrics

  Examples:
      $ mix ca.apply.config --type distillery
      $ mix ca.apply.config -t distillery
  """

  alias ElixirStructureManager.Core.ApplyTemplate
  alias Mix.Tasks.Ca.BaseTask

  use BaseTask,
    name: "ca.apply.config",
    description: "Applies project configuration",
    switches: [type: :string],
    aliases: [t: :type]

  def execute({opts, []}) when opts != nil and length(opts) > 0 do
    Mix.shell().info([:green, "* Applying configuration ", :reset, opts[:type]])

    ApplyTemplate.apply(String.to_atom(opts[:type]), "non_required")

    Mix.shell().info([:green, "* Configuration applied"])
  end

  def execute(_any), do: run(["-h"])
end
