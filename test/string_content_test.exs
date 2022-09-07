defmodule StringContentTest do
  use ExUnit.Case
  alias ElixirStructureManager.Utils.StringContent
  import ExUnit.Assertions

  test "should replace tokens" do
    content = "sample{token}replaced{token}many_{times}"
    expected = "sample_replaced_many_times"

    res = StringContent.replace(content, [{"{token}", "_"}, {"{times}", "times"}])

    assert expected === res
  end

  test "should parse name" do
    name = "use_case_name"
    expected = {:ok, "use_case_name", "UseCaseName"}

    res = StringContent.format_name(name)

    assert expected === res
  end

  test "should parse simple name" do
    name = "simple"
    expected = {:ok, "simple", "Simple"}

    res = StringContent.format_name(name)

    assert expected === res
  end

  test "should return error when invalid name" do
    name = "use case_name"
    expected = {:error, :invalid_name, "use case_name"}

    res = StringContent.format_name(name)

    assert expected === res
  end
end
