defmodule DA.SecretsManager do
  @moduledoc false
  @base "/priv/templates/adapters/secrets_manager/"

  def actions do
    %{
      create: %{
        "lib/infrastructure/driven_adapters/secrets/secrets_manager.ex" =>
          @base <> "secret_adapter.ex"
      },
      transformations: [
        {:inject_dependency, ~s|{:ex_aws_secretsmanager, "~> 2.0"}|},
        {
          :insert_after,
          "lib/config/app_config.ex",
          "\n\s\s\s\s\s:secret_name,",
          regex: ~r{defstruct(\s)+\[}
        },
        {
          :insert_after,
          "lib/config/app_config.ex",
          "\n\s\s\s\s\s\s\ssecret_name: load(:secret_name),",
          regex: ~r{%__MODULE__{}
        },
        {
          :insert_after,
          "lib/application.ex",
          "alias {app}.Infrastructure.Adapters.Secrets.SecretManagerAdapter\n  ",
          regex: ~r{Application(\s)+do(\s)+}
        },
        {
          :insert_after,
          "lib/application.ex",
          "\n\t\t\t{SecretManagerAdapter, []},",
          regex: ~r/_other_env\)(\s)+do(\s)+\[/
        }
      ]
    }
    |> Util.join_with(Config.Aws.actions())
  end

  def tokens(_opts) do
    []
  end
end
