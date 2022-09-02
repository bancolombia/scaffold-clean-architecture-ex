defmodule ElixirStructureManager.Core.ApplyModelTemplate do

  alias ElixirStructureManager.Utils.StringContent
  alias ElixirStructureManager.Utils.FileGenerator

  @model_template_path "/priv/create_structure/templates/model.txt"
  @behaviour_template_path "/priv/create_structure/templates/behaviour.txt"

  def create_model(app_name, model_name) do
    with {:ok, _app_snake_name, app_camel_name} <- StringContent.format_name(app_name),
         {:ok, model_snake_name, model_camel_name} <- StringContent.format_name(model_name) do

      project_model_path = "lib/domain/model/" <> model_snake_name <> ".ex"

      token_list = [
        %{name: "{module_name}", value: app_camel_name},
        %{name: "{model_name}", value: model_camel_name}
      ]

      FileGenerator.create_file(project_model_path, @model_template_path, token_list)
    else
      err -> Mix.raise("Invalid name indicated: " <> elem(err, 2))
    end
  end

  def create_behaviour(app_name, behaviour_name) do
    with {:ok, _app_snake_name, app_camel_name} <- StringContent.format_name(app_name),
         {:ok, behaviour_snake_name, behaviour_camel_name} <- StringContent.format_name(behaviour_name) do

      project_behaviour_path = "lib/domain/behaviours/" <> behaviour_snake_name <> ".ex"

      token_list = [
        %{name: "{module_name}", value: app_camel_name},
        %{name: "{behaviour_name}", value: behaviour_camel_name}
      ]

      FileGenerator.create_file(project_behaviour_path, @behaviour_template_path, token_list)
    else
      err -> Mix.raise("Invalid name indicated: " <> elem(err, 2))
    end
  end
  
end
