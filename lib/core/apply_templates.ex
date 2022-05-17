defmodule ElixirStructureManager.Core.ApplyTemplates do

  require Logger

  def create_variables_list(atom_name, module_name) do
    {
      :ok,
      [
        %{name: "{application_name_atom}", value: atom_name},
        %{name: "{module_name}", value: module_name}
      ]
    }
  end

  def create_folder([], _app_name, _variable_list) do
    Logger.info("Creación de la estructura terminada")
  end
  def create_folder([%{folder: folder, path: path, files: []} | tail], app_name, variable_list) do
    Logger.info("Creando directorio vacio #{folder}")
    full_path = app_name <> path
    create_content(full_path)
    create_folder(tail, app_name, variable_list)
  end
  def create_folder([%{folder: folder, path: path, files: files} | tail], app_name, variable_list) do
    Logger.info("Creando directorio #{folder}")
    full_path = app_name <> path
    create_files(files, full_path, variable_list)
    create_folder(tail, app_name, variable_list)
  end

  defp create_files([], folder_path, _variable_list), do:
    Logger.info("Archivos del directorio #{folder_path} creados")

  defp create_files([head | tail], folder_path, variable_list) do
    %{name: name, template_path: template_path} = head
    app_path = Application.app_dir(:elixir_structure_manager)
    with file_full_path <- folder_path <> "/" <> name,
         :ok <- create_content(file_full_path),
         {:ok, file_content} <- File.read(app_path <> template_path),
         full_file_content <- replace_variables(variable_list, file_content),
         :ok <- File.write(file_full_path, full_file_content) do
      create_files(tail, folder_path, variable_list)
    end
  end

  defp replace_variables([], content) do
    Logger.info("Se reemplazaron las variables")
    content
  end
  defp replace_variables([%{name: variable_name, value: value} | tail], content) do
    replace_variables(tail, String.replace(content, variable_name, value))
  end

  def manage_application_name(application_name) do
    case String.match?(application_name, ~r/^([a-zA-Z0-9]+_[a-zA-Z0-9]+){1,}$/) do
      true ->
        {
          :ok,
          application_name
          |> String.downcase(),
          Macro.camelize(application_name)
        }
      _ ->
        Logger.error("Nombre de aplicación invalido")
        {:error, :invalid_application_name}
    end
  end

  def load_template_file(read_path) do
    {content, _ignored} = Code.eval_file(read_path)
    content
  end

  def create_content(path) do
    Logger.info("Creating directory #{inspect(path)}")
    File.mkdir_p(Path.dirname(path)) |> IO.inspect()
  end
end
