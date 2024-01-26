defmodule {app}.Domain.Behaviours.TokenProvider do
  @moduledoc """
  TokenProvider
  """

  @callback get_token() :: {:ok, token :: term} | {:error, reason :: term}
end
