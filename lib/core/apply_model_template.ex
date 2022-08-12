defmodule ElixirStructureManager.Core.ApplyModelTemplate do
  
  alias ElixirStructureManager.Utils.StringContent

  @model_template_path "/priv/create_structure/templates/model.txt"
  @behaviour_template_path "/priv/create_structure/templates/behaviour.txt"

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
      
      token_list = [
        %{name: "{module_name}", value: app_camel_name},
        %{name: "{model_name}", value: model_camel_name}
      ]
      
      create_file(project_model_path, @model_template_path, token_list)
    else
      err -> Mix.raise("Invalid name indicated: " <> elem(err, 2))
    end
  end

  def create_behaviour(app_name, behaviour_name) do
    with {:ok, _app_snake_name, app_camel_name} <- format_name(app_name),
         {:ok, behaviour_snake_name, behaviour_camel_name} <- format_name(behaviour_name) do
      
      project_behaviour_path = "lib/domain/behaviours/" <> behaviour_snake_name <> ".ex"
      
      token_list = [
        %{name: "{module_name}", value: app_camel_name},
        %{name: "{behaviour_name}", value: behaviour_camel_name}
      ]
      
      create_file(project_behaviour_path, @behaviour_template_path, token_list)
    else
      err -> Mix.raise("Invalid name indicated: " <> elem(err, 2))
    end
  end

  defp create_file(project_file_path, template_path, token_list) do
    app_path = Application.app_dir(:elixir_structure_manager)

    with {:ok, file_template_content} <- File.read(app_path <> template_path) do
      
      file_content = StringContent.replace(token_list, file_template_content)
      File.write!(project_file_path, file_content)
    else
      err -> IO.inspect(err)
    end
  end
end
