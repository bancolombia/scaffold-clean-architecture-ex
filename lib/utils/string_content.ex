defmodule ElixirStructureManager.Utils.StringContent do
  @moduledoc """
  Replace variables in a string content.
  """
  def replace(content, []), do: content

  def replace(content, [{variable_name, value} | tail]) do
    replace(String.replace(content, variable_name, value), tail)
  end

  def format_name(name) do
    case String.match?(name, ~r/^([a-zA-Z0-9]+)(_[a-zA-Z0-9]+)*$/) do
      true -> {:ok, String.downcase(name), Macro.camelize(name)}
      _ -> {:error, :invalid_name, name}
    end
  end
end
