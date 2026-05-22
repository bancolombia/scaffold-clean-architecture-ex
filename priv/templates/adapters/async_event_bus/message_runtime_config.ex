defmodule {app}.Config.MessageRuntimeConfig do
  alias {app}.Config.{ConfigHolder, AppConfig}
  use ReactiveCommonsSetup

  def config() do
    %AppConfig{exchange: params} = ConfigHolder.conf()
    params
  end
end
