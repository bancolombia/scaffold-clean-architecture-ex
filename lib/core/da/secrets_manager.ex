defmodule DA.SecretsManager do
  @moduledoc false
  @base "/priv/templates/adapters/secrets_manager/"

  @props """
    \n  secret_name: "",
    secret: nil,
    config_loaders: [
      {app}.Infrastructure.Adapters.Secrets.SecretManagerAdapter
    ],
  """

  @props_after ~r/enable_server:(\s)+(true|false),/

  def actions do
    %{
      create: %{
        "lib/infrastructure/driven_adapters/secrets/secrets_manager.ex" =>
          @base <> "secret_adapter.ex"
      },
      transformations: [
        {:inject_dependency, ~s|{:ex_aws_secretsmanager, "~> 2.0"}|},
        {:add_config_attribute, "secret_name"},
        {:add_config_attribute, "secret"},
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
          regex: ~r/_other_env,(\s)*_config\)(\s)+do(\s)+\[/
        },
        {
          :insert_after,
          "config/dev.exs",
          @props,
          regex: @props_after
        },
        {
          :insert_after,
          "config/test.exs",
          @props,
          regex: @props_after
        },
        {
          :insert_after,
          "config/prod.exs",
          @props,
          regex: @props_after
        }
      ]
    }
    |> Util.join_with(Config.Aws.actions())
  end

  def tokens(_opts) do
    []
  end
end
