defmodule Mix.Tasks.Ca.Release do
  @moduledoc """
  Mix release wrapper that moves compressed artifact to _build/release/artifact folder

  Examples:
      $ mix ca.release

  It generates the following files:
  * _build/release/artifact/<app-name>.tar.gz
  """

  alias ElixirStructureManager.Utils.{FileGenerator, TokenHelper}
  alias Mix.Tasks.Ca.BaseTask

  use BaseTask,
    name: "ca.release",
    description:
      "Mix release wrapper that moves compressed artifact to _build/release/artifact folder",
    switches: [],
    aliases: []

  def execute(_any) do
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
end
