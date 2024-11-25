defmodule {app}.ApplicationTest do
  use ExUnit.Case
  doctest {app}.Application
  alias {app}.Config.{ConfigHolder, AppConfig}

  test "test childrens" do
    assert {app}.Application.env_children(:test, %AppConfig{}) == []
  end

  setup do
    if :ets.info(:{app_snake}_config) == :undefined do
      :ets.new(:{app_snake}_config, [:public, :named_table, read_concurrency: true])
    end

    :ets.delete_all_objects(:{app_snake}_config)
    :ok
  end

  test "conf/0 returns the current config when it exists" do
    config = %AppConfig{env: :test, enable_server: true, http_port: 8083}

    :ets.insert(:{app_snake}_config, {:config, config})

    assert ConfigHolder.conf() == config
  end

  test "get!/1 raises an error when the key does not exist" do
    :ets.delete_all_objects(:{app_snake}_config)

    assert_raise RuntimeError, "Config with key :nonexistent_key not found", fn ->
      ConfigHolder.get!(:nonexistent_key)
    end
  end
end
