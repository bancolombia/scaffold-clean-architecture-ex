defmodule ElixirStructureManager.Core.ApplyTemplate do
  alias Config.Metrics
  alias ElixirStructureManager.Utils.{FileGenerator, TokenHelper}

  @moduledoc """
  This module is responsible for applying the templates to the project.
  """

  def apply(type, name, opts \\ nil) do
    module = resolve_behaviour(type)

    tokens =
      TokenHelper.add("{name}", name)
      |> TokenHelper.add(module.tokens(opts))

    module.actions()
    |> Metrics.inject(type)
    |> FileGenerator.execute_actions(tokens)
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
