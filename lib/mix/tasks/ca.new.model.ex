defmodule Mix.Tasks.Ca.New.Model do
  @moduledoc """
  Creates a new model for the clean architecture project
      $ mix ca.new.model [model_name]

  Creates a new model with default behaviour name
      $ mix ca.new.model [model_name] --behaviour
      $ mix ca.new.model [model_name] --bh

  Creates a new model with behaviour name
      $ mix ca.new.model [model name] --behaviour --behaviour-name [behaviour_name]
      $ mix ca.new.model [model name] --bh --bh-name [behaviour_name]
  """

  alias ElixirStructureManager.Core.ApplyTemplate
  alias ElixirStructureManager.Utils.DataTypeUtils
  use Mix.Task

  @behaviour_string "behaviour"
  @version Mix.Project.config()[:version]
  @switches [bh: :boolean, bh_name: :string, behaviour: :boolean, behaviour_name: :string]

  def run([]) do
    Mix.Tasks.Help.run(["ca.new.model"])
  end

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info([:reset, "Scaffold version ", :green, "v#{@version}"])
  end

  @shortdoc "Creates a new model with empty properties"
  def run(argv) do
    case DataTypeUtils.parse_opts(argv, @switches) do
      {_opts, []} ->
        Mix.Tasks.Help.run(["ca.new.model"])

      {opts, [model_name | _]} ->
        ApplyTemplate.apply(:model, model_name)

        if opts[:behaviour] || opts[:bh] do
          ApplyTemplate.apply(:behaviour, behaviour_name(opts, model_name))
        end
    end
  end

  defp behaviour_name(opts, module_name) do
    if opts[:behavior_name] != nil || opts[:bh_name] != nil do
      opts[:behavior_name] || opts[:bh_name]
    else
      "#{module_name}_#{@behaviour_string}"
    end
  end
end
