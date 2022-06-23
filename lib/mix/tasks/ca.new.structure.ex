defmodule Mix.Tasks.Ca.New.Structure do

  @moduledoc """
  Creates a new Clean architecture scaffold

      $ mix create_structure [application_name]
  """

  alias ElixirStructureManager.Core.ApplyTemplates
  require Logger

  use Mix.Task

  @structure_path "/priv/create_structure/parameters/create_structure.exs"
  @version Mix.Project.config()[:version]

  @switches [dev: :boolean, assets: :boolean, ecto: :boolean,
             app: :string, module: :string, web_module: :string,
             database: :string, binary_id: :boolean, html: :boolean,
             gettext: :boolean, umbrella: :boolean, verbose: :boolean,
             live: :boolean, dashboard: :boolean, install: :boolean,
             prefix: :string, mailer: :boolean]

  def run ([]) do
    Mix.Tasks.Help.run(["ca.new.Structure"])
  end

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("Scaffold version v#{@version}")
  end

  @shortdoc "Creates a new clean architecture application."
  def run([application_name]) do
    structure_path = Application.app_dir(:elixir_structure_manager) <> @structure_path
    with {:ok, atom_name, module_name} <- ApplyTemplates.manage_application_name(application_name),
         template <- ApplyTemplates.load_template_file(structure_path),
         {:ok, variable_list} <- ApplyTemplates.create_variables_list(atom_name, module_name) do
      ApplyTemplates.create_folder(template, atom_name, variable_list)
    else
      error -> Logger.error("Ocurrio un error creando la estructura: #{inspect(error)}")
    end
  end

  def run(argv) do
    IO.puts "Sending arguments"
    IO.inspect(argv)

    opts = parse_opts(argv)
    IO.inspect(opts)

    case opts do
      {_opts, []} ->
        Mix.Tasks.Help.run(["create_structure"])

      {opts, [base_path | _]} ->
        IO.inspect(opts)
        IO.inspect(base_path)
    end
  end

  defp parse_opts(argv) do
    case OptionParser.parse(argv, strict: @switches) do
      {opts, argv, []} ->
        {opts, argv}
      {_opts, _argv, [switch | _]} ->
        Mix.raise "Invalid option: " <> switch_to_string(switch)
    end
  end

  defp switch_to_string({name, nil}), do: name
  defp switch_to_string({name, val}), do: name <> "=" <> val
end
