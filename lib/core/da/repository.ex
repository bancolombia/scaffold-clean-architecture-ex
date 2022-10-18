defmodule DA.Repository do
  @moduledoc false
  @base "/priv/templates/adapters/repository/"

  def actions() do

    %{
      create: %{
        "lib/driven_adapters/repository/repo.ex" => @base <> "repo.ex",
        "lib/driven_adapters/repository/{name_snake}/data/{name_snake}_data.ex" => @base <> "data.ex",
        "lib/driven_adapters/repository/{name_snake}/{name_snake}_data_repository.ex" => @base <> "data_repository.ex",
      },
      transformations: [
        {:inject_dependency, ~s|{:ecto_sql, "~> 3.9"}|},
        {:inject_dependency, ~s|{:postgrex, "~> 0.16"}|},
        {:append_end, "config/dev.exs", @base <> "config_to_append_dev.ex"},
        {:append_end, "config/prod.exs", @base <> "config_to_append_prod.ex"},
        {
          :insert_after,
          "lib/application.ex",
          "\n\t\t\t{{app}.Adapters.Repository.Repo, []},",
          regex: ~r/_other_env\)(\s)+do(\s)+\[/
        }
      ]
    }
  end

  def tokens(_opts) do
    []
  end
end
