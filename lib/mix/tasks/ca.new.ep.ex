defmodule Mix.Tasks.Ca.New.Ep do
  @moduledoc """
  Creates a new driven adapter for the clean architecture project
  mix ca.new.ep --type entry_point_name

  Type param options:

  * secrestsmanager

  Examples:
      $ mix ca.new.ep --type entry_point_name --name my_adapter
      $ mix ca.new.ep -t entry_point_name -n my_adapter
      $ mix ca.new.da --type asynceventhandler
      $ mix ca.new.da -t asynceventhandler

  """

  alias ElixirStructureManager.Core.ApplyTemplate
  alias ElixirStructureManager.Utils.CommonCommands
  alias Mix.Tasks.Ca.BaseTask

  use BaseTask,
    name: "ca.new.ep",
    description: "Creates a new entry point",
    switches: [type: :string, name: :string],
    aliases: [t: :type, n: :name]

  def execute({opts, []}) do
    Mix.shell().info([:green, "* Creating entry point ", :reset, opts[:type]])

    ApplyTemplate.apply(
      String.to_atom(opts[:type]),
      opts[:name] || "valid_name"
    )

    Mix.shell().info([:green, "* Entry Point created"])

    CommonCommands.install_deps()
  end

  def execute(_any), do: run(["-h"])
end
