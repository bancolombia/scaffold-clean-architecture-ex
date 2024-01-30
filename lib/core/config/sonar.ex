defmodule Config.Sonar do
  @moduledoc false
  @base "/priv/templates/config/sonar/"

  def actions do
    ignore = """
    credo_sonarqube.json
    sobelow.json
    generic_test_execution_sonarqube.xml
    """

    %{
      create: %{
        ".credo.exs" => @base <> "credo.exs",
        "test/test_helper.exs" => @base <> "test_helper.exs",
        "test/support/test_stubs.exs" => @base <> "test_stubs.exs"
      },
      transformations: [
        {:inject_dependency, ~s|{:credo_sonarqube, "~> 0.1"}|},
        {:inject_dependency, ~s|{:sobelow, "~> 0.11", only: :dev}|},
        {:inject_dependency, ~s|{:ex_unit_sonarqube, "~> 0.1", only: :test}|},
        {:append_end, ".gitignore", ignore},
        {:run_task, :install_deps}
      ]
    }
  end

  def tokens(_opts) do
    []
  end
end
