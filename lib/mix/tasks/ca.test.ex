defmodule Mix.Tasks.Ca.Test do
  @moduledoc """
  Run common static code analysis tools and tests for the project

  Examples:
      $ mix ca.test

  It generates the following files:
  * _build/release/credo_sonarqube.json
  * _build/release/excoveralls.xml
  * _build/release/generic_test_execution_sonarqube.xml
  * _build/release/sobelow.json
  * _build/release/sobelow_sonarqube.json
  * _build/release/test-junit-report.xml
  """

  alias ElixirStructureManager.Utils.{TokenHelper, FileGenerator}
  alias Mix.Tasks.Ca.BaseTask

  use BaseTask,
    name: "ca.test",
    description: "Run common static code analysis tools and tests for the project",
    switches: [],
    aliases: []

  def execute(_any) do
    Mix.shell().info([:green, "* Executing analysis and tests"])

    sonar_base_folder = Application.get_env(:elixir_structure_manager, :sonar_base_folder, "")

    args = %{
      folders: [
        "_build/release"
      ],
      transformations: [
        {:cmd,
         "mix credo --sonarqube-base-folder {sonar_base_folder} --sonarqube-file _build/release/credo_sonarqube.json --mute-exit-status"},
        {:cmd, "mix sobelow -f json --out _build/release/sobelow.json"},
        {:cmd,
         "mix ca.sobelow.sonar -i _build/release/sobelow.json -o _build/release/sobelow_sonarqube.json"},
        {:cmd, "mix coveralls.xml"},
        {:cmd,
         "mv generic_test_execution_sonarqube.xml _build/release/generic_test_execution_sonarqube.xml"}
      ]
    }

    FileGenerator.execute_actions(args, TokenHelper.add("sonar_base_folder", sonar_base_folder))

    Mix.shell().info([:green, "* Analysis executed"])
  end
end
