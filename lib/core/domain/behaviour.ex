defmodule Domain.Behaviour do
  @moduledoc false
  @base "/priv/templates/domain/"

  def actions() do
    %{
      create: %{
        "lib/domain/behaviours/{name_snake}.ex" => @base <> "behaviour.ex"
      },
      transformations: []
    }
  end

  def tokens(_opts) do
    []
  end
end
