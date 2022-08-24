defmodule ElixirStructureManager.Core.ApplyDrivenAdapterTemplate do
  
  alias ElixirStructureManager.Utils.StringContent
  alias ElixirStructureManager.Utils.FileGenerator
  alias ElixirStructureManager.Utils.Injector
  
  @project_da_path "lib/driven_adapters"
  @poject_mix_file "mix.exs"  
 
  def create_driven_adapter(app_name, da_name, type) do

    with {:ok, _app_snake_name, app_camel_name} <- StringContent.format_name(app_name),
         {:ok, da_snake_name, da_camel_name} <- StringContent.format_name(da_name) do

      {:ok, project_da_path, template_path, token_list} = create(app_camel_name, da_camel_name, da_snake_name, type)

      FileGenerator.create_file(project_da_path, template_path, token_list)
    else
      err -> Mix.raise("Invalid name indicated: " <> elem(err, 2))
    end
  end
  
  defp create(app_camel_name, _da_camel_name, _da_snake_name, :secretsmanager) do
    folder_secrets_path = "#{@project_da_path}/secrets/"
    file_secrets_path = "#{folder_secrets_path}secrets_manager.ex"

    token_list = [
      %{name: "{module_name}", value: app_camel_name},
      %{name: "{da_name}", value: "secrets_manager"}
    ]
    
    template_path = "/priv/create_structure/templates/secret_adapter.txt"
    
    if !File.exists?(@project_da_path) do
      File.mkdir!(@project_da_path)
    end

    if !File.exists?(folder_secrets_path) do
      File.mkdir!(folder_secrets_path)
    end
    
    inject_dependencies(~s|{:ex_aws_secretsmanager, "~> 2.0"}|)
    Mix.shell().info("Dependency ex_aws_secretsmanager added")

    {:ok, file_secrets_path, template_path, token_list}
  end
  
  defp create(_app_camel_name, _da_camel_name, _da_snake_name, _invalid_da) do
    Mix.raise("Invalid driven adapter parameter. Please verify de documentation to see the diferent driven adapters types")
  
  end

  defp inject_dependencies(dependency) do
    Injector.inject_dependency(@poject_mix_file, dependency)   
  end
end

