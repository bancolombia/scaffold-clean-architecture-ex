defmodule Util do
  def join_with(%{} = config, %{} = config2), do: Map.merge(config, config2, &merge/3)

  defp merge(_k, v1, v2) when is_map(v1), do: Map.merge(v1, v2, &merge/3)
  defp merge(_k, v1, v2) when is_list(v1), do: v1 ++ v2
end
