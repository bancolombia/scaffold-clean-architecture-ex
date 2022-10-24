defmodule {app}.Infrastructure.Adapters.RestConsumer.{name}.{name}Adapter do
  alias {app}.Config.ConfigHolder
  #alias {app}.Domain.Model.{name}
  #alias {app}.Infrastructure.Adapters.RestConsumer.{name}.Data.{name}Request

  def get() do
    %{{name_snake}_url: url} = ConfigHolder.conf()

    with {:ok, %Finch.Response{body: body}} <- Finch.build(:get, url) |> Finch.request(HttpFinch),
         {:ok, response} <- Poison.decode(body) do
      {:ok, response}
    end
  end

  def post(body) do
    %{{name_snake}_url: url} = ConfigHolder.conf()
    headers = [{"Content-Type", "application/json"}]

    #body = struct({name}Request, body)

    with {:ok, request} <- Poison.encode(body),
         {:ok, %Finch.Response{body: body, status: _}}
            <- Finch.build(:post, url, headers, request) |> Finch.request(HttpFinch) do

        #Poison.decode(body, as: %{name}{})
        Poison.decode(body)
    end
  end
end
