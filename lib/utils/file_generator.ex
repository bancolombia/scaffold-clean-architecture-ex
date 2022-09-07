defmodule ElixirStructureManager.Utils.FileGenerator do
  alias ElixirStructureManager.Utils.StringContent
  alias ElixirStructureManager.Utils.Injector

  def execute_actions(%{create: to_create, transformations: trs} = args, tokens) do
    create_dirs(args, tokens)
    Enum.each(to_create, &create_file(&1, tokens))
    Enum.each(trs, &transformation(&1, tokens))
  end

  defp create_dirs(%{folders: folders}, tokens) when is_list(folders) do
    Enum.each(folders, &create_dir(&1, tokens))
  end

  defp create_dirs(_, _), do: :nothing

  defp create_dir(folder, tokens) do
    folder
    |> resolve_content(tokens)
    |> File.mkdir_p!()

    Mix.shell().info([:green, "Folder ", :reset, folder, :green, " created"])
  end

  defp create_file({file, template}, tokens) when is_list(tokens) do
    with content <- resolve_content(template, tokens),
         resolved_file <- resolve_content(file, tokens),
         :ok <- ensure_dir(resolved_file) do
      File.write!(resolved_file, content)
      Mix.shell().info([:green, "File ", :reset, resolved_file, :green, " created"])
    else
      err -> IO.inspect(err)
    end
  end

  defp transformation({:inject_dependency = operation, dependency}, tokens) do
    transformation({operation, _dest_file = "mix.exs", dependency}, tokens)
  end

  defp transformation({operation, dest_file, content_or_file}, tokens) do
    transformation({operation, dest_file, content_or_file, _no_opts = nil}, tokens)
  end

  defp transformation({operation, dest_file, content_or_file, opts}, tokens) do
    dest_file
    |> read()
    |> call_injector(operation, resolve_content(content_or_file, tokens), opts)
    |> persist(dest_file)
  end

  defp call_injector(content, operation, injectable, opts) do
    apply(Injector, operation, [content, injectable, opts])
  end

  defp ensure_dir(file) do
    file
    |> String.split("/")
    |> Enum.reverse()
    |> tl()
    |> Enum.reverse()
    |> Enum.join("/")
    |> File.mkdir_p!()
  end

  defp resolve_content(content, tokens) do
    content
    |> template_file()
    |> StringContent.replace(tokens)
  end

  defp template_file(content) do
    app_path = Application.app_dir(:elixir_structure_manager)

    case File.read(app_path <> content) do
      {:ok, file_content} -> file_content
      _other -> content
    end
  end

  defp read(file), do: File.read!(file)

  defp persist({:ok, content}, file) do
    Mix.shell().info([:green, "File ", :reset, file, :green, " updated"])
    File.write!(file, content)
  end

  defp persist(other, file), do: raise("Error processing file #{file} #{inspect(other)}")
end
