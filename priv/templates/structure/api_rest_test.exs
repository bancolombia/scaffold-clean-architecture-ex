defmodule {app}.Infrastructure.EntryPoint.ApiRestTets do
  alias {app}.Infrastructure.EntryPoint.ApiRest

  use ExUnit.Case
  use Plug.Test

  @opts ApiRest.init([])

  test "test ApiRest" do
    conn =
      :get
      |> conn("/api/health", "")
      |> ApiRest.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "test Hello" do
    conn =
      :get
      |> conn("/api/hello", "")
      |> ApiRest.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

end
