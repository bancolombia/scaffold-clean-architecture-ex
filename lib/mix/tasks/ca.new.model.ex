defmodule Mix.Tasks.Ca.New.Model do
  @moduledoc """
  Creates a new model for the clean architecture project
      $ mix ca.new.model [model_name]

  Creates a new model with default behaviour name
      $ mix ca.new.model [model_name] --behaviour
      $ mix ca.new.model [model_name] -b

  Creates a new model with behaviour name
      $ mix ca.new.model [model name] --behaviour-name [behaviour_name]
      $ mix ca.new.model [model name] -n [behaviour_name]
  """

  alias ElixirStructureManager.Core.ApplyTemplate
  alias Mix.Tasks.Ca.BaseTask

  use BaseTask,
    name: "ca.new.model",
    description: "Creates a new model with empty properties",
    switches: [behaviour_name: :string, behaviour: :boolean],
    aliases: [n: :behaviour_name, b: :behaviour]

  def execute({opts, [model_name | _]}) do
    ApplyTemplate.apply(:model, model_name)

    if opts[:behaviour_name] || opts[:behaviour] do
      ApplyTemplate.apply(:behaviour, behaviour_name(opts, model_name))
    end
  end

  def execute(_any), do: run(["-h"])

  defp behaviour_name(opts, module_name), do: opts[:behaviour_name] || "#{module_name}_behaviour"
end
