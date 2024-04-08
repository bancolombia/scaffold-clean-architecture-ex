defmodule ElixirStructureManager.Utils.TokenHelper do
  alias ElixirStructureManager.Utils.StringContent
  @moduledoc false

  def add(token = {key, value}) when is_binary(key) and is_binary(value) do
    add(default_tokens(), token)
  end

  def add(key, value) when is_binary(key) and is_binary(value) do
    add(default_tokens(), key, value)
  end

  def add(tokens, token) when is_list(tokens) and is_list(token) do
    token ++ tokens
  end

  def add(tokens, {key, value}) when is_list(tokens) and is_binary(key) and is_binary(value) do
    add(tokens, key, value)
  end

  def add(tokens, key, value) when is_list(tokens) and is_binary(key) and is_binary(value) do
    [{key, value} | tokens ]
  end

  def add_boolean(tokens, key, value) when is_binary(key) do
    add(tokens, key, to_string(value || false))
  end

  def default_tokens do
    config = Mix.Project.config()
    case Keyword.fetch(config, :app) do
      :error ->
        Mix.shell().error("It is not an elixir project")
        raise "It is not an elixir project"

      {:ok, app_name} ->
        to_string(app_name)
        |> StringContent.format_name()
        |> to_token_list()
        |> add("{version}", config[:version])
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
end
