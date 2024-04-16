defmodule Mix.Tasks.Ca.Update do
  @moduledoc """
  Updates dependencies in mix.exs to their latest stable versions from hex.pm

  Examples:
      $ mix ca.update
  """
  alias Mix.Tasks.Ca.BaseTask
  alias ElixirStructureManager.Utils.Hex.Packages

  use BaseTask,
    name: "ca.update",
    description: "Updates dependencies in mix.exs to their latest stable versions from hex.pm",
    switches: [],
    aliases: []

  def execute({_opts, []}) do
    :inets.start()
    :ssl.start()
    mix_file = Mix.Project.project_file()
    mix = File.read!(mix_file)
    [_head, tail] = String.split(mix, ~r/defp\s+deps\s*\(?\)?\s+do\s*/)
    [deps_final, _] = String.split(tail, ~r/\s+end\s+/)

    deps = Mix.Project.config()[:deps]
    new_deps = "#{inspect(Enum.map(deps, &fetch_latest_version/1))}"

    new_mix = String.replace(mix, deps_final, new_deps)

    formatted = Code.format_string!(new_mix, width: 80)

    File.write!(mix_file, formatted)
  end

  def execute(_any), do: run(["-h"])

  defp fetch_latest_version(dep = {package, vsn}) when is_binary(vsn) do
    case Packages.get_stable_version(Atom.to_string(package)) do
      {:ok, {version, _config}} -> {package, "~> #{version}"}
      _ -> dep
    end
  end

  defp fetch_latest_version(dep = {_package, opts}) when is_list(opts) do
    dep
  end

  defp fetch_latest_version(dep = {package, _version, opts}) do
    case Packages.get_stable_version(Atom.to_string(package)) do
      {:ok, {version, _config}} -> {package, "~> #{version}", opts}
      _ -> dep
    end
  end
end
