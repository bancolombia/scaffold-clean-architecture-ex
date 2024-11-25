defmodule {app}.Infrastructure.EntryPoints.HealthCheckTest do
  alias {app}.Infrastructure.EntryPoint.HealthCheck

  use ExUnit.Case

  describe "checks/0" do
    test "returns a list of health checks" do
      checks = HealthCheck.checks()

      check = hd(checks)
      assert check.name == "http"
      assert check.module == HealthCheck
      assert check.function == :check_http
    end
  end

  describe "check_http/0" do
    test "returns :ok" do
      assert HealthCheck.check_http() == :ok
    end
  end

end
