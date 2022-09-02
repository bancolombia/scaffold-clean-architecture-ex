defmodule ElixirStructureManager.Utils.FileGenerator do

  alias ElixirStructureManager.Utils.StringContent

  def create_file(project_file_path, template_path, token_list) do
    app_path = Application.app_dir(:elixir_structure_manager)

    with {:ok, file_template_content} <- File.read(app_path <> template_path) do

      file_content = StringContent.replace(token_list, file_template_content)
      File.write!(project_file_path, file_content)
    else
      err -> IO.inspect(err)
    end
  end
  
end
