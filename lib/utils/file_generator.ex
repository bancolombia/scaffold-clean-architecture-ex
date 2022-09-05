defmodule ElixirStructureManager.Utils.FileGenerator do
  alias ElixirStructureManager.Utils.StringContent
  alias ElixirStructureManager.Utils.Injector

  def execute_actions(%{create: to_create, transformations: trs} = args, tokens) do
    IO.inspect args
    create_dirs(args)
    Enum.each(to_create, &create_file(&1, tokens))
    Enum.each(trs, &transformation(&1, tokens))
  end

  defp create_dirs(%{folders: folders}) when is_list(folders) do
    Enum.each(folders, &File.mkdir_p!/1)
  end

  defp create_dirs(_), do: :nothing

  defp create_file({file, template}, tokens) when is_list(tokens) do
    with content <- resolve_content(template, tokens),
         resolved_file <- IO.inspect(resolve_content(file, tokens)),
         :ok <- ensure_dir(resolved_file) do
      File.write!(resolved_file, content)
    else
      err -> IO.inspect(err)
    end
  end

  defp transformation({:inject_dependency, dependency}, _tokens) do
    dest_file = "mix.exs"

    dest_file
    |> read()
    |> Injector.inject_dependency(dependency)
    |> persist(dest_file)
  end

  defp transformation({:append_end, dest_file, content_or_file}, tokens) do
    dest_file
    |> File.read!()
    |> Injector.append_end(resolve_content(content_or_file, tokens))
    |> persist(dest_file)
  end

  defp transformation({:insert_after, dest_file, {regex, content_or_file}}, tokens) do
    dest_file
    |> read()
    |> Injector.insert_after(resolve_content(content_or_file, tokens), regex)
    |> persist(dest_file)
  end

  defp transformation({:insert_before, dest_file, {regex, content_or_file}}, tokens) do
    dest_file
    |> read()
    |> Injector.insert_before(resolve_content(content_or_file, tokens), regex)
    |> persist(dest_file)
  end

  defp ensure_dir(file) do
    file
    |> String.split("/")
    |> Enum.reverse()
    |> tl()
    |> Enum.reverse()
    |> Enum.join("/")
    |> File.mkdir_p()
  end

  defp resolve_content(content, tokens) do
    content
    |> template_file()
    |> StringContent.replace(tokens)
  end

  defp ensure_content(file, nil), do: File.read(file)
  defp ensure_content(_file, content), do: {:ok, content}

  defp template_file(content) do
    app_path = Application.app_dir(:elixir_structure_manager)

    case File.read(app_path <> content) do
      {:ok, file_content} -> file_content
      _other -> content
    end
  end

  defp read(file), do: File.read!(file)

  defp persist({:ok, content}, file) do
    Mix.shell().info([:green, "File ", :reset, file, :green, " saved"])
    File.write!(file, content)
  end

  defp persist(other, file), do: raise("Error processing file #{file} #{inspect(other)}")
end
