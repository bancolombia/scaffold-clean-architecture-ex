defmodule Domain.UseCase do
  @moduledoc false
  @base "/priv/templates/domain/"

  def actions() do
    %{
      create: %{
        "lib/domain/use_cases/{name_snake}.ex" => @base <> "usecase.ex"
      },
      transformations: []
    }
  end

  def tokens(_opts) do
    []
  end
end
