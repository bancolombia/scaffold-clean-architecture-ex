defmodule DA.Redis.Test do
  use ExUnit.Case
  alias ElixirStructureManager.Core.ApplyTemplate
  alias ElixirStructureManager.Utils.FileGenerator

  import Mock

  test "should apply transformations when secrets manager DA exists" do
    with_mocks [
      {FileGenerator, [], [execute_actions: fn _actions, _tokens -> :ok end]},
      {File, [], [
        exists?: fn _path -> true end,
        read!: fn _path -> "SecretManagerAdapter, [] \n , {:secret, secret}) \n   defp get_secret_value" end
      ]}
    ] do
      res = ApplyTemplate.apply(:redis, "sample_name")
      assert :ok == res
    end
  end

  test "should apply transformations when secrets manager DA is not as child" do
    with_mocks [
      {FileGenerator, [], [execute_actions: fn _actions, _tokens -> :ok end]},
      {File, [], [
        exists?: fn _path -> true end,
        read!: fn _path -> "\n , {:secret, secret}) \n   defp get_secret_value" end
      ]}
    ] do
      res = ApplyTemplate.apply(:redis, "sample_name")
      assert :ok == res
    end
  end

end
