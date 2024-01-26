defmodule {app}.Infrastructure.Adapters.Cognito.Data.CognitoSettings do
  defstruct [
    :endpoint,
    :credentials_provider
  ]

  def from(endpoint, credentials_provider) when is_binary(endpoint) and is_atom(credentials_provider) do
    %__MODULE__{
      endpoint: endpoint,
      credentials_provider: credentials_provider
    }
  end
end
