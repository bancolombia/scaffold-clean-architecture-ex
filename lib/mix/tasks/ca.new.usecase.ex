defmodule Mix.Tasks.Ca.New.Usecase do
  @moduledoc """
  Creates a new usecase for the clean architecture project
      $ mix ca.new.usecase [name_usecase]
  """

  alias ElixirStructureManager.Core.ApplyUseCaseTemplate
  use Mix.Task

  @version Mix.Project.config()[:version]

  def run([]) do
    Mix.Tasks.Help.run(["ca.new.usecase"])
  end

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info([:reset, "Scaffold version ", :green, "v#{@version}"])
  end

  @shortdoc "Creates a new usecase"
  def run([usecase_name]) do
    case Mix.Project.config() |> Keyword.fetch(:app) do
      :error ->
        Mix.shell().error("It is not a elixir project")

      {:ok, app_name} ->
        Mix.shell().info([:green, "* Creating usecase ", :reset, usecase_name])
        ApplyUseCaseTemplate.create_usecase(to_string(app_name), usecase_name)
        Mix.shell().info([:green, "* Usecase ", :reset, usecase_name, :green, " created"])
    end
  end
end
