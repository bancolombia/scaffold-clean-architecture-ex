defmodule DA.Generic do
  @moduledoc false
  @base "/priv/templates/adapters/generic/"

  def actions do
    %{
      create: %{
        "lib/infrastructure/driven_adapters/{name_snake}/{name_snake}.ex" => @base <> "generic.ex"
      },
      transformations: []
    }
  end

  def tokens(_opts) do
    []
  end
end
