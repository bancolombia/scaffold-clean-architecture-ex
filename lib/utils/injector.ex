defmodule ElixirStructureManager.Utils.Injector do
  @spec inject_dependency(String.t(), String.t()) ::
          {:ok, String.t()} | {:error, reason :: term}
  def inject_dependency(content, dependency) do
    insert_after(content, "\n      #{dependency},", ~r{defp deps do(\s)+\[})
  end

  def insert_before(content, insertable, regex) do
    transform_content(content, insertable, &insert_on_match(&1, regex, insertable, :before))
  end

  def insert_after(content, insertable, regex) do
    transform_content(content, insertable, &insert_on_match(&1, regex, insertable, :after))
  end

  def append_end(content, appendable) do
    transform_content(content, appendable, &{:ok, &1 <> appendable})
  end

  defp transform_content(content, insertable, transformation) do
    with false <- String.contains?(content, insertable),
         {:ok, new_content} <- transformation.(content) do
      {:ok, new_content}
    else
      true -> {:ok, content}
      {:error, reason} -> {:error, reason}
      other -> {:error, other}
    end
  end

  defp insert_on_match(content, regex, insertable, place) do
    case Regex.split(regex, content, include_captures: true) do
      [_l, _m, _r] = parts -> {:ok, concat_match(parts, insertable, place)}
      other -> {:error, {:no_match, other, regex}}
    end
  end

  defp concat_match([left, match, right], insertable, :before) do
    "#{left}#{insertable}#{match}#{right}"
  end

  defp concat_match([left, match, right], insertable, :after) do
    "#{left}#{match}#{insertable}#{right}"
  end
end
