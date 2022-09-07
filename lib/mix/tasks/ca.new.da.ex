defmodule Mix.Tasks.Ca.New.Da do
  @moduledoc """
  Creates a new driven adapter for the clean architecture project
  mix ca.new.da --type driven_adapter_name

  Type param options:

  * secrestsmanager

  Examples:
      $ mix ca.new.da --type driven_adapter_name --name my_adapter
      $ mix ca.new.da --type secrestsmanager

  """

  alias ElixirStructureManager.Core.ApplyTemplate
  alias Mix.Tasks.Ca.BaseTask

  use BaseTask,
    name: "ca.new.da",
    description: "Creates a new driven adapter",
    switches: [type: :string, name: :string]

  def execute({opts, []}) do
    Mix.shell().info([:green, "* Creating driven adapter ", :reset, opts[:type]])

    ApplyTemplate.apply(
      String.to_atom(opts[:type]),
      opts[:name] || "valid_name"
    )

    Mix.shell().info([:green, "* Driven Adapter created"])
  end

  def execute(_any), do: run([])
end
