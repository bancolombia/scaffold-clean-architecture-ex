defmodule Mix.Tasks.Ca.New.Model do
  use Mix.Task 

  @moduledoc """
  Creates a new model for the clean architecture project
      $ mix ca.new.model [model name]
  """
  @version Mix.Project.config()[:version]
  
  def run ([]) do
    IO.puts("Empty values")
    Mix.Tasks.Help.run(["ca.new.model"])
  end
  
  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("Scaffold version v#{@version}")
  end

  def run([module_name]) do
    IO.inspect(module_name)
  end

end
