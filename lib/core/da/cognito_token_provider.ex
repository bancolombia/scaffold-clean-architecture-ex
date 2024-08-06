defmodule DA.CognitoTokenProvider do
  @moduledoc false
  @base "/priv/templates/adapters/cognito_token_provider/"

  def actions do
    %{
      create: %{
        "lib/infrastructure/driven_adapters/cognito/cognito_token_provider.ex" =>
          @base <> "cognito_token_provider.ex",
        "lib/infrastructure/driven_adapters/cognito/cognito_token_provider_config.ex" =>
          @base <> "cognito_token_provider_config.ex",
        "lib/infrastructure/driven_adapters/cognito/data/cognito_credentials.ex" =>
          @base <> "cognito_credentials.ex",
        "lib/infrastructure/driven_adapters/cognito/data/cognito_settings.ex" =>
          @base <> "cognito_settings.ex",
        "lib/infrastructure/driven_adapters/cognito/data/token_response.ex" =>
          @base <> "token_response.ex",
        "lib/domain/behaviours/token_provider.ex" => @base <> "token_provider.ex"
      },
      transformations: [
        {:inject_dependency, ~s|{:finch, "~> 0.18"}|},
        {:inject_dependency, ~s|{:poison, "~> 6.0"}|},
        {
          :inject_module,
          "lib/infrastructure/driven_adapters/secrets/secrets_manager.ex",
          "alias {app}.Infrastructure.Adapters.Cognito.Data.CognitoCredentials"
        },
        {
          :inject_module,
          "lib/infrastructure/driven_adapters/secrets/secrets_manager.ex",
          "require Logger"
        },
        {
          :insert_before_last,
          "lib/infrastructure/driven_adapters/secrets/secrets_manager.ex",
          """
            def get_credentials() do
              Logger.info("Getting cognito credentials")

              if Mix.env() == :prod do
                secret_name = ConfigHolder.conf().secret_name_cognito

                get_secret_value(secret_name)
                |> Poison.decode(as: %CognitoCredentials{})
              else
                {:ok,
                CognitoCredentials.from(
                  System.get_env("COGNITO_CLIENT_ID"),
                  System.get_env("COGNITO_CLIENT_SECRET")
                )}
              end
            end
          """,
          regex: ~r{end}
        },
        {:append_end, "config/dev.exs", @base <> "config_to_append.ex",
         check: "cognito_endpoint"},
        {:append_end, "config/test.exs", @base <> "config_to_append.ex",
         check: "cognito_endpoint"},
        {:append_end, "config/prod.exs", @base <> "config_to_append.ex",
         check: "cognito_endpoint"},
        {
          :insert_after,
          "lib/config/app_config.ex",
          "\n\s\s\s\s\s\scognito_endpoint: load(:cognito_endpoint),",
          regex: ~r{%__MODULE__{}
        },
        {
          :insert_after,
          "lib/config/app_config.ex",
          "\n\s\s\s\s:cognito_endpoint,",
          regex: ~r{defstruct(\s)+\[}
        },
        {
          :insert_after,
          "lib/config/app_config.ex",
          "\n\s\s\s\s\s\scognito_credentials_provider: load(:cognito_credentials_provider),",
          regex: ~r{%__MODULE__{}
        },
        {
          :insert_after,
          "lib/config/app_config.ex",
          "\n\s\s\s\s:cognito_credentials_provider,",
          regex: ~r{defstruct(\s)+\[}
        },
        {
          :insert_after,
          "lib/application.ex",
          "\n\t\t\t{Finch, name: HttpFinch, pools: %{:default => [size: 500]}},",
          regex: ~r/all_env_children\(\)(\s)+do(\s)+\[/, check: "Finch"
        },
        {
          :inject_module,
          "lib/application.ex",
          "alias Cleanex.Infrastructure.Adapters.Cognito.CognitoTokenProviderConfig"
        },
        {
          :insert_after,
          "lib/application.ex",
          "\n\t\t\t{CognitoTokenProviderConfig, AppConfig.load_config()},",
          regex: ~r/all_env_children\(\).+do(\n.+)*Finch.*,/
        }
      ]
    }
    |> Util.join_with(DA.SecretsManager.actions())
  end

  def tokens(_opts) do
    []
  end
end
