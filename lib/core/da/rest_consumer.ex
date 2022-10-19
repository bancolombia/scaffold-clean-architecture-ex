defmodule DA.RestConsumer do
  @moduledoc false
  @base "/priv/templates/adapters/rest_consumer/"

  def actions() do

    %{
      create: %{
        "lib/driven_adapters/rest_consumer/{name_snake}/{name_snake}_adapter.ex" => @base <> "rest_consumer.ex",
        "lib/driven_adapters/rest_consumer/{name_snake}/data/{name_snake}_request.ex" => @base <> "data_request.ex",
        "lib/driven_adapters/rest_consumer/{name_snake}/data/{name_snake}_response.ex" => @base <> "data_response.ex"
      },
      transformations: [
        {:inject_dependency, ~s|{:finch, "~> 0.13"}|},
        {:inject_dependency, ~s|{:poison, "~> 4.0"}|},
        {:append_end, "config/dev.exs", @base <> "config_to_append.ex"},
        {:append_end, "config/test.exs", @base <> "config_to_append.ex"},
        {:append_end, "config/prod.exs", @base <> "config_to_append.ex"},
        {
          :insert_after,
          "lib/config/app_config.ex",
          "\n\s\s\s\s\s:{name_snake}_url,",
          regex: ~r{defstruct(\s)+\[}
        },
        {
          :insert_after,
          "lib/config/app_config.ex",
          "\n\s\s\s\s\s\s\s{name_snake}_url: load(:{name_snake}_url),",
          regex: ~r{%__MODULE__{}
        },
        {
          :insert_after,
          "lib/application.ex",
          "\n\t\t\t{Finch, name: HttpFinch, pools: %{:default => [size: 500]}},",
          regex: ~r/_other_env\)(\s)+do(\s)+\[/
        }
      ]
    }
  end

  def tokens(_opts) do
    []
  end
end
