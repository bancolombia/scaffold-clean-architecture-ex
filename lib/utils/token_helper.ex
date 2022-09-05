defmodule ElixirStructureManager.Utils.TokenHelper do
  alias ElixirStructureManager.Utils.StringContent
  @moduledoc false

  def add(key, value) when is_binary(key) and is_binary(value) do
    StringContent.format_name(value)
    |> to_token_list(key)
    |> add(default_tokens())
  end

  def add(tokens, key, value) when is_binary(key) and is_binary(value) and is_list(tokens) do
    StringContent.format_name(value)
    |> to_token_list(key)
    |> add(tokens)
  end

  def add(token) when is_tuple(token) do
    add(default_tokens(), token)
  end

  def add(tokens, token) when is_list(token) and is_list(tokens) do
    token ++ tokens
  end

  def add(tokens, token) when is_tuple(token) and is_list(tokens) do
    [token | tokens]
  end

  def default_tokens() do
    case Mix.Project.config() |> Keyword.fetch(:app) do
      :error ->
        Mix.shell().error("It is not a elixir project")
        {:error, :project_name_not_found}

      {:ok, app_name} ->
        to_string(app_name)
        |> StringContent.format_name()
        |> to_token_list()
    end
  end

  defp to_token_list({:ok, app_snake_name, app_camel_name}) do
    [{"{module_name}", app_camel_name}, {"{application_name_atom}", app_snake_name}]
  end

  defp to_token_list({:ok, app_snake_name, app_camel_name}, key) do
    [{"{#{key}_snake}", app_snake_name}, {"{#{key}}", app_camel_name}]
  end
end
