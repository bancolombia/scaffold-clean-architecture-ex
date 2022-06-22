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
    IO.inspect(model_name)

    app_name = Mix.Project.config() |> Keyword.fetch(:app)

    case app_name do
      :error -> Mix.shell().error("It is not a elixir project")
      {:ok, name} -> to_string(name) 
                      |> ApplyModelTemplate.create_model(model_name)      
    end

  end
end
