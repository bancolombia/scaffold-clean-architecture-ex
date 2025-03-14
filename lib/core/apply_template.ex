defmodule ElixirStructureManager.Core.ApplyTemplate do
  alias Config.Metrics
  alias ElixirStructureManager.Utils.{FileGenerator, StringContent, TokenHelper}

  @moduledoc """
  This module is responsible for applying the templates to the project.
  """

  def apply(type, name, opts \\ nil) do
    module = resolve_behaviour(type)

    case StringContent.format_name(name) do
      {:ok, name_snake, name_camel} ->
        metrics = Mix.Project.config()[:metrics] || false

        tokens =
          TokenHelper.add("{name}", name_camel)
          |> TokenHelper.add("{name_snake}", name_snake)
          |> TokenHelper.add(module.tokens(opts))
          |> TokenHelper.add("{metrics}", metrics)

        module.actions()
        |> Metrics.inject(type)
        |> FileGenerator.execute_actions(tokens)

      {:error, _, name} ->
        Mix.raise("Invalid name: #{name}")
    end
  end

  defp resolve_behaviour(:model), do: Domain.Model
  defp resolve_behaviour(:behaviour), do: Domain.Behaviour
  defp resolve_behaviour(:usecase), do: Domain.UseCase

  defp resolve_behaviour(:secretsmanager), do: DA.SecretsManager
  defp resolve_behaviour(:asynceventbus), do: DA.AsyncEventBus
  defp resolve_behaviour(:generic), do: DA.Generic
  defp resolve_behaviour(:redis), do: DA.Redis
  defp resolve_behaviour(:dynamo), do: DA.Dynamo
  defp resolve_behaviour(:repository), do: DA.Repository
  defp resolve_behaviour(:restconsumer), do: DA.RestConsumer
  defp resolve_behaviour(:cognitotokenprovider), do: DA.CognitoTokenProvider

  defp resolve_behaviour(:asynceventhandler), do: EP.AsyncEventHandlers

  defp resolve_behaviour(:metrics), do: Config.Metrics
  defp resolve_behaviour(:sonar), do: Config.Sonar

  defp resolve_behaviour(_other) do
    Mix.raise(
      "Invalid driven adapter parameter. Please verify de documentation to see the different domain module types"
    )
  end
end
