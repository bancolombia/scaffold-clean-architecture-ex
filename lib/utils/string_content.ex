defmodule ElixirStructureManager.Utils.StringContent do
  
  def replace([], content) do
    content
  end
  
  def replace([%{name: variable_name, value: value} | tail], content) do
    replace(tail, String.replace(content, variable_name, value))
  end
end
