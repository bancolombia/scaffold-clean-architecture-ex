defmodule DA.Redis do
  @moduledoc false
  @regex ~r/_other_env, _config\)(\s)+do(\s)+\[/
  @secrets_manager_file "lib/infrastructure/driven_adapters/secrets/secrets_manager.ex"
  @base "/priv/templates/adapters/"

  def actions do
    redis_child = get_redis_child_configuration()

    %{
      create: %{
        "lib/infrastructure/driven_adapters/redis/redis_adapter.ex" => @base <> "redis/redis.ex"
      },
      transformations:
        [
          {:inject_dependency, ~s|{:redix, "~> 1.5"}|},
          {:add_config_attribute, "redis_props", ~s/%{port: "6379", host: "localhost"}/},
          {
            :insert_after,
            "lib/application.ex",
            "alias {app}.Infrastructure.Adapters.Redis.RedisAdapter\n  ",
            regex: ~r{Application(\s)+do(\s)+}
          },
          {
            :insert_after,
            "lib/infrastructure/entry_points/health_check.ex",
            "\n\s\salias {app}.Infrastructure.Adapters.Redis.RedisAdapter",
            regex: ~r{EntryPoint.HealthCheck do}
          },
          {
            :insert_after,
            "lib/infrastructure/entry_points/health_check.ex",
            "\n\s\s\s\s\s\s%PlugCheckup.Check{name: \"redis\", module: {app}.Infrastructure.Adapters.Redis.RedisAdapter, function: :health},",
            regex: ~r{def checks do(\s)+\[}
          },
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
        ", redis_props: redis_props",
        regex: ~r/secret: secret/
      },
      {
        :insert_after,
        @secrets_manager_file,
        "\n\t\t\tredis_props = get_secret(redis_secret_name)",
        regex: ~r/get_secret\(secret_name\)/
      },
      {
        :insert_after,
        "lib/application.ex",
        "\n\t\t\t{RedisAdapter, []},",
        regex: regex
      }
    ]
  end

  defp resolve_actions(_with_secrets?, _regex) do
    [
      {
        :insert_after,
        "lib/application.ex",
        "\n\t\t\t{RedisAdapter, []},",
        regex: @regex
      }
    ]
  end
end
