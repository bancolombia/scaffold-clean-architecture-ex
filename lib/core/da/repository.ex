defmodule DA.Repository do
  @moduledoc false
  @base "/priv/templates/adapters/repository/"

  def actions do
    %{
      create: %{
        "lib/infrastructure/driven_adapters/repository/repo.ex" => @base <> "repo.ex",
        "lib/infrastructure/driven_adapters/repository/{name_snake}/data/{name_snake}_data.ex" =>
          @base <> "data.ex",
        "lib/infrastructure/driven_adapters/repository/{name_snake}/{name_snake}_data_repository.ex" =>
          @base <> "data_repository.ex"
      },
      transformations: [
        {:inject_dependency, ~s|{:ecto_sql, "~> 3.11"}|},
        {:inject_dependency, ~s|{:postgrex, "~> 0.19"}|},
        {:append_end, "config/dev.exs", @base <> "config_to_append_dev.ex"},
        {:append_end, "config/prod.exs", @base <> "config_to_append_prod.ex"},
        {
          :insert_after,
          "lib/application.ex",
          "\n\t\t\t{{app}.Infrastructure.Adapters.Repository.Repo, []},",
          regex: ~r/_other_env, _config\)(\s)+do(\s)+\[/
        }
      ]
    }
  end

  def tokens(_opts) do
    []
  end
end
