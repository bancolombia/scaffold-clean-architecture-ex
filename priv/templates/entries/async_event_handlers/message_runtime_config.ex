defmodule {app}.Config.MessageRuntimeConfig do
  alias {app}.Config.{ConfigHolder, AppConfig}
  alias {app}.Infrastructure.EntryPoint.AsyncMessageHandlers
  use ReactiveCommonsSetup

  def config() do
    %AppConfig{exchange: params} = ConfigHolder.conf()
    params
  end

  def handlers_config(), do: AsyncMessageHandlers.setup()
end
