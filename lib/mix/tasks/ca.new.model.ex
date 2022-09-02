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

  alias ElixirStructureManager.Core.ApplyModelTemplate
  alias ElixirStructureManager.Utils.DataTypeUtils
  use Mix.Task

  @behaviour_string "behaviour"
  @version Mix.Project.config()[:version]
  @switches [bh: :boolean, bh_name: :string,
             behaviour: :boolean, behaviour_name: :string]

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
        app_name_getted = Mix.Project.config() |> Keyword.fetch(:app)
        case app_name_getted do
          :error -> Mix.shell().error("It is not an elixir project")
          {:ok, app_name} ->
            project_app_name = to_string(app_name)
            create_model(project_app_name, model_name)
            if opts[:behaviour] || opts[:bh],
              do: create_behaviour(opts, project_app_name, model_name)
        end
    end
  end

  defp create_model(project_app_name, model_name) do
    Mix.shell().info([:green, "* Creating model ", :reset, model_name])

    ApplyModelTemplate.create_model(project_app_name, model_name)

    Mix.shell().info([:green, "* Model ", :reset, model_name, :green, " created"])
  end

  defp create_behaviour(opts, project_app_name, module_name) do
    behavior_name = if opts[:behavior_name] != nil || opts[:bh_name] != nil do
      (opts[:behavior_name] || opts[:bh_name])
    else
      "#{module_name}_#{@behaviour_string}"
    end
    Mix.shell().info([:green, "* Creating behaviour ", :reset, behavior_name])
    ApplyModelTemplate.create_behaviour(project_app_name, behavior_name)

    Mix.shell().info([:green, "* Behaviour ", :reset, behavior_name, :green, " created"])
  end
  
end
