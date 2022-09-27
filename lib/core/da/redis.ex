defmodule DA.Redis do
  @moduledoc false
  @regex ~r/_other_env\)(\s)+do(\s)+\[/
  @secrets_manager_file "lib/driven_adapters/secrets/secrets_manager.ex"
  @base "/priv/templates/adapters/"

  def actions() do

    redis_default_values = {
      :insert_after,
      "lib/application.ex",
      "\n\t\t\t{RedisAdapter, []},"
    }

    redis_child = if File.exists?(@secrets_manager_file)  do

      content = File.read!("lib/application.ex")

      redis_child_app = cond do
        String.contains?(content, "SecretManagerAdapter, []") ->
          {
            :insert_after,
            "lib/application.ex",
            ",\n\t\t\t{RedisAdapter, []}",
            regex: ~r/(\s)+{SecretManagerAdapter, \[\]}/
          }

        true -> Tuple.append(redis_default_values, regex: @regex)
      end

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
        redis_child_app
      ]

    else
      [Tuple.append(redis_default_values, regex: @regex)]
    end

    %{
      create: %{
        "lib/driven_adapters/redis/redis_adapter.ex" => @base <> "redis/redis.ex"
      },
      transformations: [
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
          "alias {app}.Adapters.Redis.RedisAdapter\n  ",
          regex: ~r{Application(\s)+do(\s)+}
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
end
