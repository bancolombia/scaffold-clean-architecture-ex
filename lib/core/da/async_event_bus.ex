defmodule DA.AsyncEventBus do
  @moduledoc false
  @base "/priv/templates/adapters/async_event_bus/"

  def actions() do
    %{
      create: %{
        "lib/driven_adapters/async_messages/async_messages.ex" => @base <> "async_messages.ex",
        "lib/config/message_runtime_config.ex" => @base <> "message_runtime_config.ex"
      },
      transformations: [
        {:inject_dependency, ~s|{:reactive_commons, "~> 0.7.0"}|},
        {:append_end, "config/dev.exs", @base <> "config_to_append.ex"},
        {:append_end, "config/test.exs", @base <> "config_to_append.ex"},
        {:append_end, "config/prod.exs", @base <> "config_to_append.ex"},
        {
          :insert_after,
          "lib/config/app_config.ex",
          {~r{defstruct(\s)+\[}, "\n\s\s\s\s\s:exchange,"}
        },
        {
          :insert_after,
          "lib/config/app_config.ex",
          {~r{%__MODULE__{}, "\n\s\s\s\s\s\s\sexchange: load(:exchange),"}
        },
        {
          :insert_after,
          "lib/application.ex",
          {~r/_other_env\)(\s)+do(\s)+\[(\s)+{ConfigHolder,(\s)+AppConfig.load_config\(\)},/,
           "\n\t\t\tMessageRuntimeConfig,"}
        },
        {
          :insert_after,
          "lib/application.ex",
          {~r{Application(\s)+do(\s)+}, "alias {app}.Adapters.MessageRuntimeConfig\n  "} # TODO: fix variables
        }
      ]
    }
  end

  def tokens do
    []
  end
end
