defmodule {app}.Config.MessageRuntimeConfig do
  alias {app}.Config.{ConfigHolder, AppConfig}
  alias {app}.Infrastructure.EntryPoint.AsyncMessageHandlers
  use ReactiveCommonsSetup

  defp config() do
    %AppConfig{exchange: params} = ConfigHolder.conf()
    params
  end

  defp handlers_config(), do: AsyncMessageHandlers.setup()
end
