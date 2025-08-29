defmodule DA.Redis do
  @moduledoc false
  @regex ~r/_other_env, _config\)(\s)+do(\s)+\[/
  @secrets_manager_file "lib/infrastructure/driven_adapters/secrets/secrets_manager.ex"
  @base "/priv/templates/adapters/"

  def actions do
    redis_child = get_redis_child_configuration()

    %{
      create: %{
        "lib/infrastructure/driven_adapters/redis/redis_adapter.ex" =>
          @base <> "redis/redis_adapter.ex",
        "lib/infrastructure/driven_adapters/redis/redis_setup.ex" =>
          @base <> "redis/redis_setup.ex"
      },
      transformations:
        [
          {:inject_dependency, ~s|{:redix, "~> 1.5"}|},
          {:inject_dependency, ~s|{:redix_pool, "~> 0.1", [hex: :redix_conn_pool]}|},
          {:add_config_attribute, "redis_props",
           ~s/%{port: "6379", host: "localhost", pool_size: 1, ssl: false}/},
          {
            :insert_after,
            "lib/application.ex",
            "alias {app}.Infrastructure.Adapters.Redis.RedisSetup\n  ",
            regex: ~r{Application(\s)+do(\s)+}
          },
          {
            :insert_after,
            "lib/infrastructure/entry_points/health_check.ex",
            "\n\s\salias {app}.Infrastructure.Adapters.Redis.RedisSetup",
            regex: ~r{EntryPoint.HealthCheck do}
          },
          {
            :insert_after,
            "lib/infrastructure/entry_points/health_check.ex",
            "\n\s\s\s\s\s\s%PlugCheckup.Check{name: \"redis\", module: RedisSetup, function: :health},",
            regex: ~r{def checks do(\s)+\[}
          }
        ] ++ redis_child
    }
  end

  def tokens(_opts) do
    []
  end

  defp get_redis_child_configuration do
    with_secrets? = File.exists?(@secrets_manager_file)
    resolve_actions(with_secrets?, @regex)
  end

  defp resolve_actions(true = _with_secrets?, regex) do
    [
      {:add_config_attribute, "redis_secret_name", ~s/"redis-secret-name"/},
      {
        :insert_after,
        @secrets_manager_file,
        ", redis_secret_name: redis_secret_name",
        regex: ~r/secret_name: secret_name/
      },
      {
        :insert_after,
        @secrets_manager_file,
        ", redis_secret: redis_secret",
        regex: ~r/secret: secret/
      },
      {
        :insert_after,
        @secrets_manager_file,
        "\n\t\t\tredis_secret = get_secret(redis_secret_name)",
        regex: ~r/get_secret\(secret_name\)/
      },
      {
        :insert_after,
        "lib/application.ex",
        "\n\t\t\t{RedisSetup, []},",
        regex: regex
      }
    ]
  end

  defp resolve_actions(_with_secrets?, _regex) do
    [
      {
        :insert_after,
        "lib/application.ex",
        "\n\t\t\t{RedisSetup, []},",
        regex: @regex
      }
    ]
  end
end
