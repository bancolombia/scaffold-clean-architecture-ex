defmodule Domain.Model do
  @moduledoc false
  @base "/priv/templates/domain/"

  def actions do
    %{
      create: %{
        "lib/domain/model/{name_snake}.ex" => @base <> "model.ex"
      },
      transformations: []
    }
  end

  def tokens(_opts) do
    []
  end
end
