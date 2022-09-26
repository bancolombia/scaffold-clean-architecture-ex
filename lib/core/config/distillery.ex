defmodule Config.Distillery do
  @moduledoc false

  def actions() do
    %{transformations: [{:inject_dependency, ~s|{:distillery, "~> 2.1"}|}]}
  end

  def tokens(_opts) do
    []
  end
end
