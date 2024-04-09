defmodule ElixirStructureManager.Utils.CommonCommands do
  @moduledoc false
  require Logger

  def install_deps(cwd \\ nil), do: run_no_ci("mix", ["deps.get"], cwd)

  def config_sonar(cwd \\ nil), do: run("mix", ["ca.apply.config", "-t", "sonar"], cwd)

  def config_metrics(cwd \\ nil), do: run("mix", ["ca.apply.config", "-t", "metrics"], cwd)

  def run_no_ci(cmd, args, cwd) do
    ci_env = System.get_env("CI_ENV", "false")
    Logger.info("Resolved ci_env #{ci_env}")

    if ci_env == "true" do
      Logger.info("Skiping action because ci_env #{ci_env}")
    else
      run(cmd, args, cwd)
    end
  end

  def run(cmd, args, cwd) do
    log_cms = "#{cmd} #{Enum.join(args, " ")}"
    Mix.shell().info([:green, "Running '#{log_cms}'"])
    {_, exit_code} = System.cmd(cmd, args, into: IO.stream(), cd: resolve_dir(cwd))

    if exit_code != 0 do
      Mix.shell().error([:red, "Command '#{log_cms}' failed with exit code #{exit_code}"])
      # exit(exit_code)
    end
  end

  def resolve_dir(nil), do: File.cwd!()
  def resolve_dir(dir), do: dir
end
