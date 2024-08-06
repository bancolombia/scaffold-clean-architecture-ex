defmodule Mix.Tasks.Ca.New.Structure do
  @moduledoc """
  Creates a new Clean architecture scaffold
      $ mix ca.new.structure [application_name]
      $ mix ca.new.structure [application_name] --metrics --sonar --monorepo
      $ mix ca.new.structure [application_name] -m -s -r
  """

  alias ElixirStructureManager.Utils.{CommonCommands, DataTypeUtils, FileGenerator, TokenHelper}
  alias Mix.Tasks.Help
  alias Structure.Root
  use Mix.Task

  @version Mix.Project.config()[:version]
  @switches [metrics: :boolean, sonar: :boolean, monorepo: :boolean, acceptance: :boolean]
  @aliases [m: :metrics, s: :sonar, r: :monorepo]

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
      snake_name = Macro.underscore(application_name)

      tokens =
        TokenHelper.initial_tokens(application_name)
        |> TokenHelper.add(Root.tokens(opts))
        |> TokenHelper.add(base_dir(opts, snake_name))
        |> TokenHelper.add(acceptance(opts))

      Root.actions()
      |> FileGenerator.execute_actions(tokens)

      root_dir = project_dir(snake_name)

      CommonCommands.install_deps(root_dir)

      if opts[:sonar] do
        CommonCommands.config_sonar(root_dir)
      end

      if opts[:metrics] do
        CommonCommands.config_metrics(root_dir)
      end

      CommonCommands.format(root_dir)

      Mix.shell().info([:blue, "To Execute the application run:"])
      Mix.shell().info([:green, "cd #{snake_name}"])
      Mix.shell().info([:green, "iex -S mix"])
    end
  end

  defp project_dir(application_name) do
    File.cwd!()
    |> Path.join(application_name)
  end

  defp base_dir(opts, application_name) do
    if opts[:monorepo] do
      [{"{base_dir}", "#{application_name}/"}, {"{base_dir_sonar}", "#{application_name}/"}]
    else
      [{"{base_dir}", "./"}, {"{base_dir_sonar}", ""}]
    end
  end

  defp acceptance(opts) do
    if opts[:acceptance] do
      [{"{plugin-dependency}", ""}]
    else
      [{"{plugin-dependency}", ~s/{:elixir_structure_manager, ">= 0.0.0", only: [:dev, :test]}/}]
    end
  end
end
