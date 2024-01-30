defmodule ElixirStructureManager.Utils.CommonCommands do
  @moduledoc false
  require Logger

  def install_deps(cwd \\ nil), do: run_no_ci("mix", ["deps.get"], cwd)

  def distillery_init(cwd \\ nil), do: run_no_ci("mix", ["distillery.init"], cwd)

  def config_distillery(cwd \\ nil), do: run("mix", ["ca.apply.config", "-t", "distillery"], cwd)

  def config_metrics(cwd \\ nil), do: run("mix", ["ca.apply.config", "-t", "metrics"], cwd)

  defp run_no_ci(cmd, args, cwd) do
    ci_env = System.get_env("CI_ENV", "false")
    Logger.info("Resolved ci_env #{ci_env}")

    if ci_env == "true" do
      Logger.info("Skiping action because ci_env #{ci_env}")
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
