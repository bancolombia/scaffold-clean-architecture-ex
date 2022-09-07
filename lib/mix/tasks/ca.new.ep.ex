defmodule Mix.Tasks.Ca.New.Ep do
  @moduledoc """
  Creates a new driven adapter for the clean architecture project
  mix ca.new.ep --type entry_point_name

  Type param options:

  * secrestsmanager

  Examples:
      $ mix ca.new.ep --type entry_point_name --name my_adapter
      $ mix ca.new.da --type asynceventhandler

  """

  alias ElixirStructureManager.Core.ApplyTemplate
  alias Mix.Tasks.Ca.BaseTask

  use BaseTask,
    name: "ca.new.ep",
    description: "Creates a new entry point",
    switches: [type: :string, name: :string]

  def execute({opts, []}) do
    Mix.shell().info([:green, "* Creating entry point ", :reset, opts[:type]])

    ApplyTemplate.apply(
      String.to_atom(opts[:type]),
      opts[:name] || "valid_name"
    )

    Mix.shell().info([:green, "* Entry Point created"])
  end

  def execute(_any), do: run([])
end
