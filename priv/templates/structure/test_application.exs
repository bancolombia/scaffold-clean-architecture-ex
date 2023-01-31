defmodule {app}.ApplicationTest do
  use ExUnit.Case
  doctest {app}.Application

  test "test childrens" do
    assert {app}.Application.env_children(:test) == []
  end
end
