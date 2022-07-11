defmodule Mix.Tasks.Ca.New.Model do

  @moduledoc """
  Creates a new model for the clean architecture project
      $ mix ca.new.model [model name]
  """
  alias ElixirStructureManager.Core.ApplyModelTemplate
  use Mix.Task
  
  @version Mix.Project.config()[:version]

  def run([]) do
    Mix.Tasks.Help.run(["ca.new.model"])
  end

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info [:reset, "Scaffold version ", :green, "v#{@version}"]
  end

  @shortdoc "Creates a new model with empty properties"
  def run([model_name]) do
    Mix.shell().info [:green, "* Creating model ", :reset, model_name]
    app_name_getted = Mix.Project.config() |> Keyword.fetch(:app)

    case app_name_getted do
      :error -> Mix.shell().error("It is not a elixir project")
      {:ok, app_name} -> to_string(app_name) 
                      |> ApplyModelTemplate.create_model(model_name)      
      Mix.shell().info [:green, "* Model ", :reset, model_name, :green, " created"]
    end

  end
end
