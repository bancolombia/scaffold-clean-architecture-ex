defmodule Mix.Task.CreateDrivenAdapter do

  use Mix.Task

  @shortdoc "Simply calls the CreateStructure.Create/0 function."
  def run(x) do
    IO.inspect(x)
    Mix.Task.run("app.start")


    # calling our Hello.say() function from earlier
    # GenerateConfig.create_config_files()
  end
end
