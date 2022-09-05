defmodule Mix.Tasks.Ca.New.Usecase do
  @moduledoc """
  Creates a new usecase for the clean architecture project
      $ mix ca.new.usecase [name_usecase]
  """

  alias ElixirStructureManager.Core.ApplyTemplate
  use Mix.Task

  @version Mix.Project.config()[:version]

  def run([]) do
    Mix.Tasks.Help.run(["ca.new.usecase"])
  end

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info([:reset, "Scaffold version ", :green, "v#{@version}"])
  end

  @shortdoc "Creates a new usecase"
  def run([use_case_name]) do
    ApplyTemplate.apply(:usecase, use_case_name)
  end
end
