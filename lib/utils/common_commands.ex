defmodule ElixirStructureManager.Utils.CommonCommands do
  @moduledoc false
  require Logger

  def install_deps(cwd \\ nil), do: run_no_env("mix", ["deps.get"], cwd)

  def distillery_init(cwd \\ nil), do: run_no_env("mix", ["distillery.init"], cwd)

  def config_distillery(cwd \\ nil), do: run("mix", ["ca.apply.config", "-t", "distillery"], cwd)

  def config_metrics(cwd \\ nil), do: run("mix", ["ca.apply.config", "-t", "metrics"], cwd)

  defp run_no_env(cmd, args, cwd, ignore_env \\ ["test"]) do
    env = System.get_env("MIX_ENV", "prod")
    Logger.info("Resolved env #{env}")

    if Enum.member?(ignore_env, env) do
      Logger.info("Skiping action because env #{env}")
    else
      run(cmd, args, cwd)
    end
  end

  defp run(cmd, args, cwd) do
    Mix.shell().info([:green, "Running '#{cmd} #{Enum.join(args, " ")}'"])
    System.cmd(cmd, args, into: IO.stream(), cd: resolve_dir(cwd))
  end

  defp resolve_dir(nil), do: File.cwd!()
  defp resolve_dir(dir), do: dir
end
