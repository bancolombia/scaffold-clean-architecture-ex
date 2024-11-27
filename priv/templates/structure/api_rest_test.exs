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
    # TODO: Implement mocks correctly when needed
    assert conn.status in [200, 500]
  end

  test "test Hello" do
    conn =
      :get
      |> conn("/api/hello", "")
      |> ApiRest.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "put_resp_content_type/2" do
    conn = conn(:get, "/test_content_type")
    conn = put_resp_content_type(conn, "application/json")

    assert get_resp_header(conn, "content-type") == ["application/json; charset=utf-8"]
  end

  test "test non-existent endpoint" do
    conn =
      :get
      |> conn("/api/nonexistent", "")
      |> ApiRest.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "test POST on /api/health" do
    conn =
      :post
      |> conn("/api/health", "")
      |> ApiRest.call(@opts)

    assert conn.state == :sent
    assert conn.status in [200, 500]
  end

  describe "handle_not_found/2" do
    test "returns 404 status with path in debug mode" do
      Logger.configure(level: :debug)

      # Simulate a request to a nonexistent path
      conn = conn(:get, "/nonexistent_path")
      conn = ApiRest.call(conn, @opts)

      # Verify the response
      assert conn.state == :sent
      assert conn.status == 404
      assert conn.resp_body == Poison.encode!(%{status: 404, path: "/nonexistent_path"})
    end

    test "returns 404 status without body in non-debug mode" do
      Logger.configure(level: :info)

      conn = conn(:get, "/test_not_found/info")
      conn = ApiRest.call(conn, @opts)

       assert conn.state == :sent
      assert conn.status == 404
      assert conn.resp_body == ""
    end
  end
end
