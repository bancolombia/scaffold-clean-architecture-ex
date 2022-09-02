defmodule Mix.Tasks.Ca.New.Da do
  @moduledoc """
  Creates a new driven adapter for the clean architecture project
      $ mix ca.new.da --type driven_adapter_name

  Type param options:

  * secrestsmanager

  Examples:
      $ mix ca.new.da --type driven_adapter_name --name my_adapter
      $ mix ca.new.da --type secrestsmanager

  """

  alias ElixirStructureManager.Core.ApplyDrivenAdapterTemplate
  alias ElixirStructureManager.Utils.DataTypeUtils
  use Mix.Task

  @version Mix.Project.config()[:version]
  @switches [type: :string, name: :string]

  def run([]) do
    Mix.Tasks.Help.run(["ca.new.da"])
  end

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info([:reset, "Scaffold version ", :green, "v#{@version}"])
  end

  @shortdoc "Creates a new driven adapter"
  def run(args) do
    case Mix.Project.config() |> Keyword.fetch(:app) do
      :error ->
        Mix.shell().error("It is not a elixir project")

      {:ok, app_name} ->
       apply_template(app_name, args) 
    end
  end

  defp apply_template(app_name, args) do

    case DataTypeUtils.parse_opts(args, @switches) do
          {opts, []} ->

            Mix.shell().info([:green, "* Creating driven adapter ", :reset, opts[:type]])
            ApplyDrivenAdapterTemplate.create_driven_adapter(
              to_string(app_name),
              opts[:name] || "valid_name",
              String.to_atom(opts[:type])
            )

            Mix.shell().info([:green, "* Driven Adapter created"])
          {_opts, [_ | _]} ->
            Mix.Tasks.Help.run(["ca.new.model"])
        end
  end

end
