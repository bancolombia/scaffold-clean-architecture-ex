defmodule EP.AsyncEventHandlers do
  @moduledoc false
  @base "/priv/templates/entries/async_event_handlers/"

  def actions do
    %{
      create: %{
        "lib/infrastructure/entry_points/async_messages/async_message_handlers.ex" =>
          @base <> "async_message_handlers.ex",
        "lib/config/message_runtime_config.ex" => @base <> "message_runtime_config.ex"
      },
      transformations: [
        {:inject_dependency, ~s|{:reactive_commons, "~> 1.2"}|},
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
