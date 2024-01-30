defmodule Mix.Tasks.Ca.New.Structure do
  @moduledoc """
  Creates a new Clean architecture scaffold
      $ mix ca.new.structure [application_name]
      $ mix ca.new.structure [application_name] --metrics --distillery
      $ mix ca.new.structure [application_name] -m -d
  """

  alias ElixirStructureManager.Utils.{CommonCommands, DataTypeUtils, FileGenerator, TokenHelper}
  alias Mix.Tasks.Help
  alias Structure.Root
  use Mix.Task

  @version Mix.Project.config()[:version]
  @switches [metrics: :boolean, distillery: :boolean]
  @aliases [m: :metrics, d: :distillery]

  def run([]), do: run(["-h"])

  def run([help]) when help in ~w(-h --help) do
    Help.run(["ca.new.structure"])
  end

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("Scaffold version v#{@version}")
  end

  @shortdoc "Creates a new clean architecture application."
  def run(argv) do
    with {opts, [application_name]} <- DataTypeUtils.parse_opts(argv, @switches, @aliases) do
      tokens =
        TokenHelper.initial_tokens(application_name)
        |> TokenHelper.add(Root.tokens(opts))

      Root.actions()
      |> FileGenerator.execute_actions(tokens)

      root_dir = project_dir(application_name)

      CommonCommands.install_deps(root_dir)

      if opts[:distillery] do
        CommonCommands.config_distillery(root_dir)
      end

      if opts[:metrics] do
        CommonCommands.config_metrics(root_dir)
      end

      Mix.shell().info([:blue, "To Execute the application run:"])
      Mix.shell().info([:green, "cd #{application_name}"])
      Mix.shell().info([:green, "iex -S mix"])
    end
  end

  defp project_dir(application_name) do
    File.cwd!()
    |> Path.join(application_name)
  end
end
