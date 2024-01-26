defmodule {app}.Infrastructure.Adapters.Cognito.Data.CognitoCredentials do
  defstruct [
    :client_id,
    :client_secret
  ]

  def from(client_id, client_secret) do
    %__MODULE__{
      client_id: client_id,
      client_secret: client_secret
    }
  end

  def to_request(%__MODULE__{} = token_request) do
    %{
      grant_type: "client_credentials",
      client_id: token_request.client_id,
      client_secret: token_request.client_secret
    }
  end
end
