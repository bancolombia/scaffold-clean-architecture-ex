defmodule ElixirStructureManager.Utils.StringContent do
  #  def replace(content, tokens) when is_list(tokens) do
  #    Enum.reduce()
  #  end

  def replace(content, []) do
    content
  end

  def replace(content, [{variable_name, value} | tail]) do
    replace(String.replace(content, variable_name, value), tail)
  end

  def format_name(name) do
    case String.match?(name, ~r/^([a-zA-Z0-9]+_[a-zA-Z0-9]+){1,}$/) do
      true ->
        {
          :ok,
          String.downcase(name),
          Macro.camelize(name)
        }

      _ ->
        {:error, :invalid_name, name}
    end
  end
end
