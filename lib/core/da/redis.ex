defmodule DA.Redis do
  @moduledoc false
  @regex ~r/_other_env\)(\s)+do(\s)+\[/
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
          {:inject_dependency, ~s|{:redix, "~> 1.0"}|},
          {
            :insert_after,
            "lib/config/app_config.ex",
            "\n\s\s\s\s\s:redis_props,",
            regex: ~r{defstruct(\s)+\[}
          },
          {
            :insert_after,
            "lib/config/app_config.ex",
            "\n\s\s\s\s\s\s\sredis_props: load(:redis_props),",
            regex: ~r{%__MODULE__{}
          },
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
          {
            :append_end,
            "config/dev.exs",
            @base <> "redis/config_to_append_dev.ex"
          },
          {
            :append_end,
            "config/test.exs",
            @base <> "redis/config_to_append.ex"
          },
          {
            :append_end,
            "config/prod.exs",
            @base <> "redis/config_to_append.ex"
          }
        ] ++ redis_child
    }
  end

  def tokens(_opts) do
    []
  end

  defp get_redis_child_configuration do
    with_secrets? = File.exists?(@secrets_manager_file)

    regex =
      if with_secrets? &&
           String.contains?(File.read!("lib/application.ex"), "SecretManagerAdapter, []") do
        ~r/(\s)+{SecretManagerAdapter, \[\]}/
      else
        @regex
      end

    resolve_actions(with_secrets?, regex)
  end

  defp resolve_actions(true = _with_secrets?, regex) do
    [
      {
        :insert_after,
        @secrets_manager_file,
        "\n\t\t\t## TODO: Uncomment to use redis with secrets\n\t\t\t# handle_redis_secrets(secret)",
        regex: ~r/, \{:secret, secret\}\)/
      },
      {
        :insert_before,
        @secrets_manager_file,
        @base <> "secrets_manager/handle_redis_secrets.ex",
        regex: ~r/  defp get_secret_value/
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
