defmodule ElixirStructureManager.Utils.Injector do
  
  @spec inject_dependency(String.t(), String.t()) ::
          :ok | :already_injected | {:error, :unable_to_inject}
  def inject_dependency(file_path, dependency) do

    file_content = File.read!(file_path)

    with :ok <- ensure_not_already_injected(file_content, dependency),
         {:ok, new_file_content} <- do_mix_dependency_inject(file_content, dependency) do
      File.write!(file_path, new_file_content)
    end
  
  end
  
  @spec inject_dependency(String.t(), String.t(), String.t()) ::
          :ok | :already_injected | {:error, :unable_to_inject}
  def inject_dependency(file_content, file_path, dependency) do

    with :ok <- ensure_not_already_injected(file_content, dependency),
         {:ok, new_file_content} <- do_mix_dependency_inject(file_content, dependency) do
      File.write!(file_path, new_file_content)
    end

  end

  @spec do_mix_dependency_inject(String.t(), String.t()) ::
          {:ok, String.t()} | {:error, :unable_to_inject}
  defp do_mix_dependency_inject(mixfile, dependecy) do
    deps_header = """
    defp deps do
        [
    """
    case String.split(mixfile, ~r{defp deps do(\s)+\[}) do
      [left, right] ->
        new_mixfile =
          "#{left}#{deps_header}      #{dependecy},#{right}"
        {:ok, new_mixfile}
      [_] -> 
        {:error, :unable_to_inject}
    end

  end

  @spec ensure_not_already_injected(String.t(), String.t()) :: :ok | :already_injected
  defp ensure_not_already_injected(file, inject) do
    if String.contains?(file, inject) do
      :already_injected
    else
      :ok
    end
  end
end
