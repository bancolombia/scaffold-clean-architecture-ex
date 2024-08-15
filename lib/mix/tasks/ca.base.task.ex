defmodule Mix.Tasks.Ca.BaseTask do
  @callback execute(args :: term) :: term
  @moduledoc """
  Generic base task for all tasks in this project.
  """
  require Logger

  defmacro __using__(opts) do
    quote do
      alias ElixirStructureManager.Utils.CommonCommands
      alias ElixirStructureManager.Utils.DataTypeUtils
      alias Mix.Tasks.Help
      use Mix.Task
      require Logger

      @version Mix.Project.config()[:version]
      @switches unquote(opts[:switches] || [])
      @aliases unquote(opts[:aliases] || [])
      @name unquote(opts[:name])

      @impl Mix.Task
      def run([help]) when help in ~w(-h --help) do
        Help.run([@name])
      end

      @impl Mix.Task
      def run([version]) when version in ~w(-v --version) do
        Mix.shell().info([:reset, "Scaffold version ", :green, "v#{@version}"])
      end

      @impl Mix.Task
      @shortdoc unquote(opts[:description])
      def run(argv) do
        res =
          DataTypeUtils.parse_opts(argv, @switches, @aliases)
          |> execute()

        unquote(
          if opts[:format] != false do
            quote do
              CommonCommands.format()
            end
          end
        )

        res
      end
    end
  end
end
