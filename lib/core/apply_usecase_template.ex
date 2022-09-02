defmodule ElixirStructureManager.Core.ApplyUseCaseTemplate do

  alias ElixirStructureManager.Utils.StringContent
  alias ElixirStructureManager.Utils.FileGenerator

  @usecase_template_path "/priv/create_structure/templates/usecase.txt"

  def create_usecase(app_name, usecase_name) do
    with {:ok, _app_snake_name, app_camel_name} <- StringContent.format_name(app_name),
         {:ok, usecase_snake_name, usecase_camel_name} <- StringContent.format_name(usecase_name) do

      project_model_path = "lib/domain/use_cases/" <> usecase_snake_name <> ".ex"

      token_list = [
        %{name: "{module_name}", value: app_camel_name},
        %{name: "{usecase_name}", value: usecase_camel_name}
      ]

      FileGenerator.create_file(project_model_path, @usecase_template_path, token_list)
    else
      err -> Mix.raise("Invalid name indicated: " <> elem(err, 2))
    end
  end
  
end
