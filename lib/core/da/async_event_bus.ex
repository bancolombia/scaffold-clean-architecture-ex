defmodule DA.AsyncEventBus do
  @moduledoc false
  @base "/priv/templates/adapters/async_event_bus/"

  def actions do
    %{
      create: %{
        "lib/infrastructure/driven_adapters/async_messages/async_messages.ex" =>
          @base <> "async_messages.ex",
        "lib/config/message_runtime_config.ex" => @base <> "message_runtime_config.ex"
      },
      transformations: [
        {:inject_dependency, ~s|{:reactive_commons, "~> 1.0"}|},
        {:append_end, "config/dev.exs", @base <> "config_to_append.ex"},
        {:append_end, "config/test.exs", @base <> "config_to_append.ex"},
        {:append_end, "config/prod.exs", @base <> "config_to_append.ex"},
        {
          :insert_after,
          "lib/config/app_config.ex",
          "\n\s\s\s\s\s:exchange,",
          regex: ~r{defstruct(\s)+\[}
        },
        {
          :insert_after,
          "lib/config/app_config.ex",
          "\n\s\s\s\s\s\s\sexchange: load(:exchange),",
          regex: ~r{%__MODULE__{}
        },
        {
          :insert_after,
          "lib/application.ex",
          "\n\t\t\tMessageRuntimeConfig,",
          regex: ~r/_other_env, _config\)(\s)+do(\s)+\[/
        },
        {
          :insert_after,
          "lib/application.ex",
          "alias {app}.Config.MessageRuntimeConfig\n  ",
          regex: ~r{Application(\s)+do(\s)+}
        }
      ]
    }
  end

  def tokens(_opts) do
    []
  end
end
