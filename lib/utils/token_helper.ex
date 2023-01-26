defmodule ElixirStructureManager.Utils.TokenHelper do
  alias ElixirStructureManager.Utils.StringContent
  @moduledoc false

  def add(token) when is_tuple(token) do
    add(default_tokens(), token)
  end

  def add(key, value) when is_binary(key) and is_binary(value) do
    StringContent.format_name(value)
    |> to_token_list(key)
    |> add(default_tokens())
  end

  def add(tokens, token) when is_list(token) and is_list(tokens) do
    token ++ tokens
  end

  def add(tokens, token) when is_tuple(token) and is_list(tokens) do
    [token | tokens]
  end

  def add(tokens, key, value) when is_binary(key) and is_binary(value) and is_list(tokens) do
    StringContent.format_name(value)
    |> to_token_list(key)
    |> add(tokens)
  end

  def add_boolean(tokens, key, value) when is_binary(key) do
    add(tokens, {key, to_string(value || false)})
  end

  def default_tokens() do
    case Mix.Project.config() |> Keyword.fetch(:app) do
      :error ->
        Mix.shell().error("It is not an elixir project")
        raise "It is not an elixir project"

      {:ok, app_name} ->
        to_string(app_name)
        |> StringContent.format_name()
        |> to_token_list()
    end
  end

  def initial_tokens(app_name) do
    app_name
    |> StringContent.format_name()
    |> to_token_list()
  end

  defp to_token_list({:ok, app_snake_name, app_camel_name}) do
    [{"{app}", app_camel_name}, {"{app_snake}", app_snake_name}]
  end

  defp to_token_list({:ok, app_snake_name, app_camel_name}, key) do
    [{"{#{key}_snake}", app_snake_name}, {"{#{key}}", app_camel_name}]
  end
end
