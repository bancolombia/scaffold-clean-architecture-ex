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
  alias ElixirStructureManager.Utils.DataTypeUtils
  use Mix.Task

  @version Mix.Project.config()[:version]
  @switches [type: :string, name: :string]

  def run([]) do
    Mix.Tasks.Help.run(["ca.new.ep"])
  end

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info([:reset, "Scaffold version ", :green, "v#{@version}"])
  end

  @shortdoc "Creates a new entry point"
  def run(args) do
    case DataTypeUtils.parse_opts(args, @switches) do
      {opts, []} ->
        Mix.shell().info([:green, "* Creating entry point ", :reset, opts[:type]])

        ApplyTemplate.apply(
          String.to_atom(opts[:type]),
          opts[:name] || "valid_name"
        )

        Mix.shell().info([:green, "* Entry Point created"])

      {_opts, [_ | _]} ->
        Mix.Tasks.Help.run(["ca.new.ep"])
    end
  end
end
