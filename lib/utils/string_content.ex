defmodule ElixirStructureManager.Utils.StringContent do
  
  def replace([], content) do
    content
  end
  
  def replace([%{name: variable_name, value: value} | tail], content) do
    replace(tail, String.replace(content, variable_name, value))
  end
  
  def format_name(name) do
    case String.match?(name, ~r/^([a-zA-Z0-9]+_[a-zA-Z0-9]+){1,}$/) do
      true ->
        {
          :ok,
          name
          |> String.downcase(),
          Macro.camelize(name)
        }

      _ ->
        {:error, :invalid_name, name}
    end
  end

end
