defmodule ElixirStructureManager.Utils.StringContent do
  @moduledoc """
  Replace variables in a string content.
  """

  def replace(content, vars) when is_list(vars) do
    if String.contains?(content, "<%=") do
      bindings = Enum.map(vars, fn {k, v} -> parse_to_bindings(k, v) end)
      EEx.eval_string(content, bindings)
    else
      replace_strings(content, vars)
    end
  end

  def replace_strings(content, []), do: content

  def replace_strings(content, [{variable_name, value} | tail]) do
    replace_strings(String.replace(content, variable_name, to_string(value)), tail)
  end

  def format_name(name) do
    case String.match?(name, ~r/^([a-zA-Z0-9]+)(_[a-zA-Z0-9]+)*$/) do
      true -> {:ok, Macro.underscore(name), Macro.camelize(name)}
      _ -> {:error, :invalid_name, name}
    end
  end

  defp parse_to_bindings(k, v) do
    atom_k =
      String.replace_prefix(k, "{", "")
      |> String.replace_suffix("}", "")
      |> String.to_atom()

    {atom_k, v}
  end
end
