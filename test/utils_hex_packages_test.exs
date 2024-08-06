defmodule ElixirStructureManager.Utils.Hex.PackagesTest do
  use ExUnit.Case
  alias ElixirStructureManager.Utils.Hex.Packages
  import Mock

  test "get_stable_version fetches package information from hex.pm" do
    body =
      Poison.encode!(%{
        "latest_stable_version" => "1.0.0",
        "configs" => %{"mix.exs" => "config_data"}
      })

    with_mock :httpc, request: fn _, _, _, _ -> {nil, {{nil, 200, "OK"}, [], body}} end do
      assert {:ok, {"1.0", "config_data"}} = Packages.get_stable_version("package_name")
    end
  end

  test "fail get_stable_version fetches package information from hex.pm" do
    with_mock :httpc,
      request: fn _, _, _, _ -> {nil, {{nil, 500, "Internal Server Error"}, [], ""}} end do
      assert {:error, "Request failed with status code 500 Internal Server Error"} =
               Packages.get_stable_version("package_name")
    end
  end

  test "fail making request" do
    with_mock :httpc, request: fn _, _, _, _ -> {:error, "Bad Request"} end do
      assert {:error, "Request failed with error \"Bad Request\""} =
               Packages.get_stable_version("package_name")
    end
  end

  test "fail decoding response" do
    with_mock :httpc, request: fn _, _, _, _ -> {nil, {{nil, 200, "OK"}, [], "\"key\" true"}} end do
      assert {:error, "Failed to parse response \"\\\"key\\\" true\""} =
               Packages.get_stable_version("package_name")
    end
  end
end
