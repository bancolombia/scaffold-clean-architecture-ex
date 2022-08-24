defmodule ElixirStructureManager.Utils.DataTypeUtils do

  def normalize(%{__struct__: _} = value), do: value

  def normalize(%{} = map) do
    Map.to_list(map)
    |> Enum.map(fn {key, value} -> {String.to_atom(key), normalize(value)} end)
    |> Enum.into(%{})
  end

  def normalize(value) when is_list(value), do: Enum.map(value, &normalize/1)
  def normalize(value), do: value
  
  def parse_opts(argv, switches) do
    case OptionParser.parse(argv, strict: switches) do
      {opts, argv, []} ->
        {opts, argv}
      {_opts, _argv, [switch | _]} ->
        Mix.raise "Invalid option: " <> switch_to_string(switch)
    end
  end

  defp switch_to_string({name, nil}), do: name
end
