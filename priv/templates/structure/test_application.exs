defmodule {app}.ApplicationTest do
  use ExUnit.Case
  doctest {app}.Application
  alias {app}.Config.AppConfig

  test "test childrens" do
    assert {app}.Application.env_children(:test, %AppConfig{}) == []
  end
end
