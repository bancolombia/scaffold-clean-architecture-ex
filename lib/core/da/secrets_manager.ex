defmodule DA.SecretsManager do
  @moduledoc false
  @base "/priv/templates/adapters/secrets_manager/"

  def actions() do
    %{
      create: %{
        "lib/driven_adapters/secrets/secrets_manager.ex" => @base <> "secret_adapter.ex"
      },
      transformations: [
        {:inject_dependency, ~s|{:ex_aws_secretsmanager, "~> 2.0"}|},
        {
          :insert_after,
          "lib/config/app_config.ex",
          {~r{defstruct(\s)+\[}, "\n\s\s\s\s\s:secret_name,"}
        },
        {
          :insert_after,
          "lib/config/app_config.ex",
          {~r{%__MODULE__{}, "\n\s\s\s\s\s\s\ssecret_name: load(:secret_name),"}
        }
      ]
    }
  end

  def tokens(_opts) do
    []
  end
end
