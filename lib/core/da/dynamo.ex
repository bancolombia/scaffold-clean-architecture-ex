defmodule DA.Dynamo do
  @moduledoc false
  @base "/priv/templates/adapters/dynamo/"

  def actions() do
    %{
      create: %{
        "lib/driven_adapters/dynamo/dynamo_adapter.ex" => @base <> "dynamo_adapter.ex",
        "lib/driven_adapters/dynamo/user_repository.ex" => @base <> "user_repository.ex",
        "lib/domain/model/user.ex" => @base <> "user.ex"
      },
      transformations: [
        {:inject_dependency, ~s|{:ex_aws_dynamo, "~> 4.0"}|},
        {:append_end, "config/dev.exs", @base <> "config_to_append.ex"},
        {:append_end, "config/test.exs", @base <> "config_to_append_test.ex"},
        {:append_end, "config/prod.exs", @base <> "config_to_append_prod.ex"}
      ]
    }
    |> Config.Aws.join_with()
  end

  def tokens(_opts) do
    []
  end
end
