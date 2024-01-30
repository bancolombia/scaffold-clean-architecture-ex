defmodule Ca.New.UsecaseTest do
  use ExUnit.Case

  import Mock
  alias ElixirStructureManager.Core.ApplyTemplate
  alias Mix.Tasks.Ca.New.Usecase, as: Task

  test "should shows helper information when invalid args" do
    assert :ok === Task.run(["invalid", "args"])
  end

  test "should create an usecase" do
    with_mocks([{ApplyTemplate, [], [apply: fn _type, _name -> :ok end]}]) do
      Task.run(["usecase_name"])
      assert called(ApplyTemplate.apply(:usecase, "usecase_name"))
    end
  end
end
