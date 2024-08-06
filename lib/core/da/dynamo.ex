defmodule DA.Dynamo do
  @moduledoc false
  @base "/priv/templates/adapters/dynamo/"

  def actions do
    %{
      create: %{
        "lib/infrastructure/driven_adapters/dynamo/dynamo_adapter.ex" =>
          @base <> "dynamo_adapter.ex",
        "lib/infrastructure/driven_adapters/dynamo/user_repository.ex" =>
          @base <> "user_repository.ex",
        "lib/domain/model/user.ex" => @base <> "user.ex"
      },
      transformations: [
        {:inject_dependency, ~s|{:ex_aws_dynamo, "~> 4.2"}|},
        {:append_end, "config/dev.exs", @base <> "config_to_append.ex"}
      ]
    }
    |> Util.join_with(Config.Aws.actions())
  end

  def tokens(_opts) do
    []
  end
end
