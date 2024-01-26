defmodule {app}.Infrastructure.Adapters.Cognito.Data.TokenResponse do
  defstruct [
    :access_token,
    :expires_in,
    :token_type
  ]
end
