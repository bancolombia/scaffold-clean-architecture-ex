defmodule {app}.Infrastructure.Adapters.Cognito.CognitoTokenProvider do
  @behaviour {app}.Domain.Behaviours.TokenProvider

  def get_token() do
    {:error, :not_implemented}
  end
end

defmodule {app}.Infrastructure.Adapters.Cognito.CognitoTokenProviderBuilder do
  alias {app}.Infrastructure.Adapters.Cognito.Data.TokenResponse

  def redefine(%TokenResponse{access_token: token}) do
    Code.eval_string("""
    defmodule {app}.Infrastructure.Adapters.Cognito.CognitoTokenProvider do
      @behaviour {app}.Domain.Behaviours.TokenProvider

      def get_token() do
        {:ok, "#{token}"}
      end
    end
    """)
    :ok
  end
end
