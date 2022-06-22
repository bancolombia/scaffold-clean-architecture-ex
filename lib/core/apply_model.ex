defmodule ElixirStructureManager.Core.ApplyModelTemplate do

  @model_path "/priv/create_structure/templates/model.txt"
  
  def format_name(name) do
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
    Mix.shell().info [:green, "* Creating model ", :reset, model_name]
    with {:ok, _app_snake_name, app_camel_name} <- format_name(app_name),
         {:ok, model_snake_name, model_camel_name} <- format_name(model_name)
    do
      project_path = "lib/domain/model/" <> model_snake_name <> ".ex" 
      content = create_file() |> replace_variables(app_camel_name, model_camel_name)

      File.write!(project_path, content)

      Mix.shell().info [:green, "* Model ", :reset, model_name, :green, " created"]
    else
      {:error, :invalid_name, name} -> Mix.shell().error [:red, "Invalid name ", :reset, name]    
    end
  
  end

  def create_file() do
    app_path = Application.app_dir(:elixir_structure_manager)
    with {:ok, file_content} <- File.read(app_path <> @model_path) do
        file_content
      else
        err -> IO.inspect(err)
      end
  end

  def replace_variables(content, app_name, model_name) do
    String.replace(content, "{application_name}", app_name)
    |> String.replace("{model_name}", model_name)
  end
end
