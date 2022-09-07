defmodule Mix.Tasks.Ca.New.Model do
  @moduledoc """
  Creates a new model for the clean architecture project
      $ mix ca.new.model [model_name]

  Creates a new model with default behaviour name
      $ mix ca.new.model [model_name] --behaviour
      $ mix ca.new.model [model_name] --bh

  Creates a new model with behaviour name
      $ mix ca.new.model [model name] --behaviour --behaviour-name [behaviour_name]
      $ mix ca.new.model [model name] --bh --bh-name [behaviour_name]
  """

  alias ElixirStructureManager.Core.ApplyTemplate
  alias Mix.Tasks.Ca.BaseTask

  use BaseTask,
    name: "ca.new.model",
    description: "Creates a new model with empty properties",
    switches: [bh: :boolean, bh_name: :string, behaviour: :boolean, behaviour_name: :string]

  def execute({opts, [model_name | _]}) do
    ApplyTemplate.apply(:model, model_name)

    if opts[:behaviour] || opts[:bh] do
      ApplyTemplate.apply(:behaviour, behaviour_name(opts, model_name))
    end
  end

  def execute(_any), do: run([])

  defp behaviour_name(opts, module_name) do
    if opts[:behavior_name] != nil || opts[:bh_name] != nil do
      opts[:behavior_name] || opts[:bh_name]
    else
      "#{module_name}_behaviour"
    end
  end
end
