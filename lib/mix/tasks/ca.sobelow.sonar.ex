defmodule Mix.Tasks.Ca.Sobelow.Sonar do
  @moduledoc """
  Translates the sobelow json report to sonar issues

  Examples:
      $ mix ca.sobelow.sonar -i sobelow.json -o sobelow_sonarqube.json
  """

  alias ElixirStructureManager.Reports.Sobelow
  alias Mix.Tasks.Ca.BaseTask

  use BaseTask,
    name: "ca.sobelow.sonar",
    description: "Translates the sobelow json report to sonar issues",
    switches: [input: :string, output: :string],
    aliases: [i: :input, o: :output]

  def execute({opts, []}) do
    Mix.shell().info([:green, "* Translating sobelow report"])

    input = Keyword.get(opts, :input, "sobelow.json")
    output = Keyword.get(opts, :output, "sobelow_sonarqube.json")

    sonar_base_folder = Application.get_env(:elixir_structure_manager, :sonar_base_folder, "")

    File.exists?(input) || Mix.shell().error([:red, "* Input file not found"])

    report =
      File.read!(input)
      |> Poison.decode!()

    sonar_report = Sobelow.translate(report, sonar_base_folder)
    json = Poison.encode!(sonar_report, %{pretty: true})
    File.write!(output, json)

    Mix.shell().info([:green, "* Sonarqube report generated"])
  end

  def execute(_any), do: run(["-h"])
end
