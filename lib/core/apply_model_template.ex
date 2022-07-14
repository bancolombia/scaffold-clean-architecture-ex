defmodule ElixirStructureManager.Core.ApplyModelTemplate do
  
  alias ElixirStructureManager.Utils.StringContent

  @model_template_path "/priv/create_structure/templates/model.txt"

  defp format_name(name) do
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

  def create_model(app_name, model_name) do
    with {:ok, _app_snake_name, app_camel_name} <- format_name(app_name),
         {:ok, model_snake_name, model_camel_name} <- format_name(model_name) do
      project_model_path = "lib/domain/model/" <> model_snake_name <> ".ex"

      create_file(app_camel_name, model_camel_name, project_model_path)
    else
      err -> Mix.raise("Invalid name indicated: " <> elem(err, 2))
    end
  end

  defp create_file(app_name, model_name, project_model_path) do
    app_path = Application.app_dir(:elixir_structure_manager)

    with {:ok, file_template_content} <- File.read(app_path <> @model_template_path) do
      token_list = [
        %{name: "{module_name}", value: app_name},
        %{name: "{model_name}", value: model_name}
      ]

      file_content = StringContent.replace(token_list, file_template_content)
      File.write!(project_model_path, file_content)
    else
      err -> IO.inspect(err)
    end
  end
end
