defmodule ElixirStructureManager.Core.ApplyDrivenAdapterTemplate do
  alias ElixirStructureManager.Utils.{StringContent, FileGenerator, Injector, TokenHelper}

  @project_da_path "lib/driven_adapters"
  @project_cf_path "lib/config"
  @project_mix_file "mix.exs"

  def create_driven_adapter(type, name) do
    module = resolve_behaviour(type)

    tokens =
      TokenHelper.add("da_name", name)
      |> TokenHelper.add(module.tokens())

    module.actions()
    |> FileGenerator.execute_actions(tokens)
  end

  defp resolve_behaviour(:secretsmanager), do: DA.SecretsManager
  defp resolve_behaviour(:asynceventbus), do: DA.AsyncEventBus

  defp resolve_behaviour(other),
    do:
      Mix.raise(
        "Invalid driven adapter parameter. Please verify de documentation to see the different driven adapters types"
      )
end
