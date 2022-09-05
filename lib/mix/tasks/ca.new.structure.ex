defmodule Mix.Tasks.Ca.New.Structure do
  @moduledoc """
  Creates a new Clean architecture scaffold

      $ mix create_structure [application_name]
  """

  alias ElixirStructureManager.Utils.{FileGenerator, TokenHelper}
  use Mix.Task

  @version Mix.Project.config()[:version]

  def run([]) do
    Mix.Tasks.Help.run(["ca.new.structure"])
  end

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("Scaffold version v#{@version}")
  end

  @shortdoc "Creates a new clean architecture application."
  def run([application_name]) do
    tokens = TokenHelper.initial_tokens(application_name)
    IO.inspect tokens

    Structure.Root.actions()
    |> FileGenerator.execute_actions(tokens)
  end
end
