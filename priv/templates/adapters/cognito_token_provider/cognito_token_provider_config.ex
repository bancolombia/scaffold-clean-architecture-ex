defmodule {app}.Infrastructure.Adapters.Cognito.CognitoTokenProviderConfig do
  alias {app}.Infrastructure.Adapters.Cognito.CognitoTokenProviderBuilder
  alias {app}.Config.AppConfig
  alias {app}.Infrastructure.Adapters.Cognito.Data.{
    CognitoCredentials,
    CognitoSettings,
    TokenResponse
  }

  require Logger

  use GenServer
  @retry_interval 5_000

  def start_link(%AppConfig{cognito_endpoint: endpoint, cognito_credentials_provider: provider}) do
    GenServer.start_link(__MODULE__, CognitoSettings.from(endpoint, provider), name: __MODULE__)
  end

  @impl true
  def init(args = %CognitoSettings{}) do
    send(self(), :generate_token)
    {:ok, args}
  end

  @impl true
  def handle_info(:generate_token, settings = %CognitoSettings{credentials_provider: provider}) do
    with {:ok, credentials = %CognitoCredentials{}} <- provider.get_credentials(),
         {:ok, token = %TokenResponse{}} <- cognito_request(settings, credentials),
         :ok <- CognitoTokenProviderBuilder.redefine(token) do
      schedule_next_token_generation(token)
      {:noreply, settings}
    else
      other ->
        Logger.warning("Failed to generate token: #{inspect(other)} retrying in 5 seconds")
        Process.send_after(self(), :generate_token, @retry_interval)
    end

    {:noreply, settings}
  end

  defp cognito_request(%CognitoSettings{endpoint: endpoint}, credentials = %CognitoCredentials{}) do
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]

    with body = URI.encode_query(CognitoCredentials.to_request(credentials)),
         {:ok, %Finch.Response{body: body, status: _}} <-
           Finch.build(:post, endpoint, headers, body) |> Finch.request(HttpFinch) do
      Poison.decode(body, as: %TokenResponse{})
    end
  end

  defp schedule_next_token_generation(%TokenResponse{expires_in: expires_in}) do
    next_event = (expires_in - 60) * 1_000
    Logger.info("Token will be refreshed in #{next_event} milliseconds")
    Process.send_after(self(), :generate_token, next_event)
  end
end
