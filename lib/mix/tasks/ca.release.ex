defmodule Mix.Tasks.Ca.Release do
  @moduledoc """
  Run common static code analysis tools and tests for the project
  Run mix release and move compressed artifact to _build/release/artifact folder

  Examples:
      $ mix ca.release

  It generates the following files:
  * _build/release/credo_sonarqube.json
  * _build/release/excoveralls.xml
  * _build/release/generic_test_execution_sonarqube.xml
  * _build/release/sobelow.json
  * _build/release/sobelow_sonarqube.json
  * _build/release/test-junit-report.xml
  * _build/release/artifact/<app-name>.tar.gz

  You can skip some task with --skip-test or --skip-release options:
      $ mix ca.release --no-test
      $ mix ca.release --no-release

  You can run the tasks inside a container with --container option:
      $ mix ca.release --container

      this uses the following configuration:
      * container_tool: docker
      * container_file: Dockerfile-build
      * container_base_image: 1.16.2-otp-26-alpine

      You can change the configuration in config/config.exs with:

      config :elixir_structure_manager,
        container_file: "Dockerfile-build",
        container_base_image: "1.16.2-otp-26-alpine",
        container_tool: "docker"
  """

  alias ElixirStructureManager.Utils.{FileGenerator, TokenHelper}
  alias Mix.Tasks.Ca.BaseTask

  use BaseTask,
    name: "ca.release",
    description: "Mix ca tasks runner for release and tests",
    switches: ["skip-test": :boolean, "skip-release": :boolean, container: :boolean],
    aliases: []

  def execute({opts, []}) do
    in_container = Keyword.get(opts, :container, false)
    skip_release = Keyword.get(opts, :"skip-release", false)
    skip_test = Keyword.get(opts, :"skip-test", false)

    if in_container do
      run_in_container(skip_release, skip_test)
    else
      execute_local(skip_release, skip_test)
    end
  end

  def execute_local(skip_release, skip_test) do
    if !skip_test do
      run_tests()
    end

    if !skip_release do
      run_release()
    end
  end

  defp run_tests do
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

  defp run_release do
    Mix.shell().info([:green, "* Generating release artifact"])

    args = %{
      folders: [
        "_build/prod/rel/{app_snake}/releases/RELEASES",
        "_build/release/artifact"
      ],
      transformations: [
        {:cmd, "mix release --overwrite"},
        {:cmd,
         "mv _build/prod/{app_snake}-{version}.tar.gz _build/release/artifact/{app_snake}.tar.gz"},
        {:cmd, "ls -lR _build/release"}
      ]
    }

    FileGenerator.execute_actions(args, TokenHelper.default_tokens())

    Mix.shell().info([:green, "* Artifact generated"])
  end

  defp run_in_container(skip_release, skip_test) do
    Mix.shell().info([:green, "* Generating release artifact inside a container"])
    container_tool = Application.get_env(:elixir_structure_manager, :container_tool, "docker")

    container_file =
      Application.get_env(:elixir_structure_manager, :container_file, "Dockerfile-build")

    container_base_image =
      Application.get_env(
        :elixir_structure_manager,
        :container_base_image,
        "1.16.2-otp-26-alpine"
      )

    args = %{
      folders: [
        "_build"
      ],
      transformations: [
        {:cmd, "rm -rf _build/release"},
        {:cmd,
         "#{container_tool} build --build-arg IMAGE=#{container_base_image} --build-arg SKIP_RELEASE=#{skip_release} --build-arg SKIP_TEST=#{skip_test} -t {app_snake} -f #{container_file} ."},
        {:cmd, "#{container_tool} stop {app_snake} || true"},
        {:cmd, "#{container_tool} rm {app_snake} || true"},
        {:cmd, "#{container_tool} run -d --name {app_snake} {app_snake}"},
        {:cmd, "#{container_tool} cp {app_snake}:/app/_build/release _build/release"},
        {:cmd, "#{container_tool} stop {app_snake} || true"},
        {:cmd, "#{container_tool} rm {app_snake} || true"},
        {:cmd, "#{container_tool} rmi {app_snake} --force"},
        {:cmd, "ls -lR _build/release"}
      ]
    }

    FileGenerator.execute_actions(args, TokenHelper.default_tokens())

    Mix.shell().info([:green, "* Artifact generated using #{container_tool}"])
  end
end
